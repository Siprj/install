#!/bin/bash -xe

PROG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

declare SKIP_AUR=false
declare SKIP_PIP=false
declare SKIP_PACMAN=false
declare SKIP_SYSTEM_SETUP=false
declare SKIP_RUST=false
declare SKIP_RUST_TOOLS=false
declare GPU_ACCELERATION=false
declare SETUP_TELEPORT=false
declare SKIP_FONTS=false
declare INSTALL_TUXEDO=false

function pacman_setp() {
    declare -a packages=(
        base-devel
        cmake
        cups
        docker
        docker-buildx
        wezterm
        neovim
        # Firewall
        ufw
        gdb
        git
        git-lfs
        github-cli
        graphviz
        gwenview
        ghidra
        hunspell
        hunspell-en_GB
        jq
        kate
        libreoffice-fresh
        okular
        freerdp
        rdesktop
        remmina
        rustup
        # Scanner app
        sane
        steam
        teamspeak3
        thefuck
        tree
        unrar
        unzip
        vlc
        wget
        wireshark-qt
        tealdeer
        zk
        krita
        element-desktop
        yaml-language-server
        helix
        ripgrep
        taplo-cli
        # Alternative tools
        lsd
        bat
        btop
        exa
        zoxide
        fd
        sd
        procs
        bottom
        broot
        )

    sudo pacman -Sy --noconfirm
    sudo pacman -Sy --needed "${packages[@]}"

    # Try to enable pacman colors
    sudo sed -i "s/#Color/Color/" "/etc/pacman.conf"
}

function aur_step () {
    pacman -Q paru || yay -S --noconfirm --answerdiff=None paru
    pacman -Q spotify || paru -S spotify --noconfirm
    pacman -Q lazygit || paru -S lazygit --noconfirm
    pacman -Q teleport-bin || paru -S teleport-bin --noconfirm
}

function font_step () {
    mkdir -p ~/.local/share/fonts/

    curl -L --proto '=https' https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip -o /tmp/FireCode.zip
    (cd ~/.local/share/fonts/ && unzip -o /tmp/FireCode.zip)
    rm /tmp/FireCode.zip
}

function rust_step () {
    rustup toolchain install nightly
    rustup default nightly
    rustup component add rust-src
    rustup component add rust-analyzer
    rustup update
}

function rust_tools_step() {
    cargo install xcp
    cargo install topgrade
}

function system_setup_step() {

sudo systemctl daemon-reload

# Firewall setup
sudo systemctl enable ufw.service
sudo systemctl start ufw.service

sudo ufw default deny
sudo ufw enable

sudo usermod --append --groups docker `whoami`

# Install oh-my-posh
if [[ ! -f "${HOME}/.local/bin/oh-my-posh" ]]; then
    mkdir -p  "${HOME}/.local/bin/"
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
fi

# Put stack, ghcup, cargo, cabal bin paths into path
cat > ~/.zprofile <<EOF
typeset -U path
path+=(~/.local/bin)
path+=(~/.ghcup/bin)
path+=(~/.cabal/bin)
path+=(~/.cargo/bin)
EOF

mkdir -p ~/.config/rofi/ && cp ${PROG_DIR}/rofi.rasi ~/.config/rofi/config.rasi

# Set git behaviour
git config --global commit.verbose true
git config --global core.editor nvim
git config --global rebase.autosquash true

mkdir -p ~/.config/
if [ -d "${HOME}/.config/nvim" ] && [ ! -L "${HOME}/.config/nvim" ]; then
    rm -r -f "${HOME}/.config/nvim"
fi
if [ ! -L "${HOME}/.config/nvim" ]; then
    ln -s "${PROG_DIR}/nvim" "${HOME}/.config/nvim"
fi
nvim -u ~/.config/nvim/init.vim +PlugUpgrade +PlugUpdate +PlugClean! +qall

mkdir -p ~/.config/lazygit/
cat > ~/.config/lazygit/config.yml <<EOF
  gui:
    theme:
      selectedLineBgColor:
        - reverse
  git:
    pull:
      mode: 'rebase'
EOF

# Install wezterm configuration
if [ ! -L "${HOME}/.wezterm.lua" ]; then
    ln -s "${PROG_DIR}/wezterm.lua" ~/.wezterm.lua
fi

mkdir -p "${HOME}/.zsh"
cp zshrc "${HOME}/.zshrc"
cp terminal-title.zsh "${HOME}/.zsh/terminal-title.zsh"

# Rescan fonts
fc-cache -r -v

mkdir -p "${HOME}/.local/bin/"
cp "${PROG_DIR}/run-hls.sh" "${HOME}/.local/bin/"

cp "${PROG_DIR}/blue.sh" "${HOME}/.local/bin/"

cp "${PROG_DIR}/toggle-keyboard.sh" "${HOME}/.local/bin/"

#cp "${PROG_DIR}/switch-workspace.py" "${HOME}/.local/bin/"

}

function setup_teleport() {
    read -p "teleport proxy domain name: " TELEPORT_PROXY_NAME
    tsh login --ttl=20 -o /tmp/short-lived-teleport-key --proxy="${TELEPORT_PROXY_NAME}"
    TOKEN_AND_CA_PIN=$(tctl -i /tmp/short-lived-teleport-key --auth-server="${TELEPORT_PROXY_NAME}" nodes add)
    TOKEN=$(echo ${TOKEN_AND_CA_PIN} | grep "\-\-token=" | sed "s/.*token=\(\S*\).*/\1/")
    CA_PIN=$(echo ${TOKEN_AND_CA_PIN} | grep "\-\-ca-pin=" | sed "s/.*ca-pin=\(\S*\).*/\1/")

    sudo mkdir -p /etc/teleport/

    sudo bash -c "cat > /etc/teleport/teleport.yaml" <<EOF
teleport:
  nodename: "$(cat /etc/hostname)"
  auth_token: "${TOKEN}"
  ca_pin:
    - "${CA_PIN}"
  auth_servers:
    - "https://${TELEPORT_PROXY_NAME}:443"
auth_service:
  enabled: false
proxy_service:
  enabled: false
ssh_service:
  enabled: true
  labels:
    env: personal
EOF

    sudo systemctl enable teleport.service
    sudo systemctl start teleport.service
}

function install_tuxedo() {
    mhwd-kernel -li
    sudo pacman -S linux-headers
    sudo pacman -S tuxedo-control-center tuxedo-keyboard-dkms
}

function print_help() {
cat << EOF
Usage: install.sh [OPTION]

  -p --skip-pacman          don't install/update standard arch packages
  -a --skip-aur             don't install/update packages form AUR
  -i --skip-pip             don't install packages with pip
  -f --skip-fonts           don't install fonts
  -r --skip-rust            don't install/update rust tool chain
  -t --skip-rust-tools      don't install/update tools build in rust
  -s --skip-system-setup    don't try to setup system setup
  -g --gpu-acceleration     set GPU acceleration method to legacy mode
  -l --teleport             configure this machine as teleport node
  -u --tuxedo               install tuxedo specific drivers and apps
EOF
}

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -p|--skip-pacman)
    SKIP_PACMAN=true
    shift # past argument
    ;;
    -a|--skip-aur)
    SKIP_AUR=true
    shift # past argument
    ;;
    -f|--skip-fonts)
    SKIP_FONTS=true
    shift # past argument
    ;;
    -i|--skip-pip)
    SKIP_PIP=true
    shift # past argument
    ;;
    -r|--skip-rust)
    SKIP_RUST=true
    shift # past argument
    ;;
    -t|--skip-rust-tools)
    SKIP_RUST_TOOLS=true
    shift # past argument
    ;;
    -s|--skip-system-setup)
    SKIP_SYSTEM_SETUP=true
    shift # past argument
    ;;
    -g|--gpu-acceleration)
    GPU_ACCELERATION=true
    shift # past argument
    ;;
    -l|--teleport)
    SETUP_TELEPORT=true
    shift # past argument
    ;;
    -u|--tuxedo)
    INSTALL_TUXEDO=true
    shift # past argument
    ;;
    -h|--help)
    print_help
    exit 0
    shift # past argument
    ;;
    *)    # unknown option
    echo "ERROR: unknown argument [${key}]"
    print_help
    exit 1
    shift # past argument
    ;;
esac
done

if [[ ${SKIP_PACMAN} == false ]]; then
    pacman_setp
fi
if [[ ${SKIP_RUST} == false ]]; then
    rust_step
fi
if [[ ${SKIP_AUR} == false ]]; then
    aur_step
fi
if [[ ${SKIP_FONTS} == false ]]; then
    font_step
fi
if [[ ${SKIP_RUST_TOOLS} == false ]]; then
    rust_tools_step
fi
if [[ ${SKIP_SYSTEM_SETUP} == false ]]; then
    system_setup_step
fi
if [[ ${INSTALL_TUXEDO} == true ]]; then
    install_tuxedo
fi

if [[ ${GPU_ACCELERATION} == true ]]; then
    sudo mkdir -p "/etc/X11/xorg.conf.d/"
    sudo cp "${PROG_DIR}/20-amdgpu.conf" "/etc/X11/xorg.conf.d/"
    sudo cp "${PROG_DIR}/20-intell.conf" "/etc/X11/xorg.conf.d/"
fi

if [[ ${SETUP_TELEPORT} == true ]]; then
    setup_teleport
fi

