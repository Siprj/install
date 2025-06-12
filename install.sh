#!/bin/bash -xe

PROG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

declare SKIP_AUR=false
declare SKIP_PIP=false
declare SKIP_PACMAN=false
declare SKIP_SYSTEM_SETUP=false
declare SKIP_RUST=false
declare SKIP_RUST_TOOLS=false
declare AUDIO_SUSPENSION=false
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
        eza
        zoxide
        fd
        sd
        procs
        bottom
        broot
        wireplumber
        pavucontrol
        lua-language-server
        gvfs-smb
        blueman
        thunar
        xdg-desktop-portal-gtk
        flameshot
        bind
        swaylock
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
    pacman -Q dropbox || paru -S dropbox --noconfirm
    pacman -Q papirus-folders-catppuccin-git || paru -S papirus-folders-catppuccin-git --noconfirm
    pacman -Q colloid-catppuccin-gtk-theme-git || paru -S colloid-catppuccin-gtk-theme-git --noconfirm
    pacman -Q catppuccin-cursors-mocha || paru -S catppuccin-cursors-mocha --noconfirm
    pacman -Q kvantum-theme-catppuccin-git || paru -S kvantum-theme-catppuccin-git --noconfirm
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

sudo systemctl start systemd-resolved.service
sudo systemctl enable systemd-resolved.service

systemctl enable --now --user wob.socket

# Firewall setup
sudo systemctl enable ufw.service
sudo systemctl start ufw.service

sudo ufw default deny
sudo ufw enable

sudo usermod --append --groups docker `whoami`

sudo sed -i "s/cs_CZ/en_US/" "/etc/locale.conf"

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

mkdir -p ~/.config/profile.d/
cp "${PROG_DIR}/paths.sh" ~/.config/profile.d/

mkdir -p ~/.config/rofi/ && cp "${PROG_DIR}/rofi.rasi" ~/.config/rofi/config.rasi
mkdir -p ~/.local/share/rofi/themes/ && cp "${PROG_DIR}/catppuccin-mocha-modified.rasi" ~/.local/share/rofi/themes/catppuccin-mocha-modified.rasi

mkdir -p ~/.config/qt5ct/colors/ && cp "${PROG_DIR}/qt-5-Catppuccin-Mocha-modified.conf" ~/.config/qt5ct/colors/Catppuccin-Mocha-Modified.conf
mkdir -p ~/.config/qt6ct/colors/ && cp "${PROG_DIR}/qt-6-Catppuccin-Mocha-modified.conf" ~/.config/qt5ct/colors/Catppuccin-Mocha-Modified.conf
cp "${PROG_DIR}/qt5ct.conf" ~/.config/qt5ct/qt5ct.conf
cp "${PROG_DIR}/qt6ct.conf" ~/.config/qt6ct/qt6ct.conf

papirus-folders -C cat-mocha-lavender --theme Papirus-Dark

mkdir -p ~/.config/swaylock/
curl https://raw.githubusercontent.com/catppuccin/catppuccin/cad3fe6c9eb2476f9787c386a6b9c70de8e6d468/assets/logos/exports/1544x1544_circle.png -o ~/.config/swaylock/catppuccin-logo.png
if [ ! -L "${HOME}/.config/swaylock/config" ]; then
    rm -R -f "${HOME}/.config/swaylock/config"
    ln -s "${PROG_DIR}/swaylock.config" "${HOME}/.config/swaylock/config"
fi

mkdir -p ~/.config/sway/
if [ ! -L "${HOME}/.config/sway/config" ]; then
    rm -R -f "${HOME}/.config/sway/config"
    ln -s "${PROG_DIR}/sway.config" "${HOME}/.config/sway/config"
fi

mkdir -p ~/.config/sway/config.d/
if [ ! -L "${HOME}/.config/sway/config.d/outputs.config" ]; then

    rm -R -f "${HOME}/.config/sway/config.d/outputs.config"

    OPTIONS=("Three screens"
             "One screen")

    select option in "${OPTIONS[@]}"
    do
        case $option in
            "Three screens")
                ln -s "${PROG_DIR}/sway-three-outputs.config" "${HOME}/.config/sway/config.d/outputs.config"
                break
                ;;
            "One screen")
                ln -s "${PROG_DIR}/sway-one-outputs.config" "${HOME}/.config/sway/config.d/outputs.config"
                break
                ;;
        esac
    done

fi

systemctl --user disable swayrd
systemctl --user disable sworkstyle

# Get this-is-the-sway workspace switching utility
curl -L --proto '=https'  https://github.com/Siprj/this-is-the-sway/releases/download/v0.0.1/this-is-the-sway.zip -o /tmp/this-is-the-sway.zip
(cd /usr/local/bin/ && sudo unzip -o /tmp/this-is-the-sway.zip && sudo chmod +x this-is-the-sway)
sudo cp "${PROG_DIR}/this-is-the-sway.service" /usr/lib/systemd/user/
systemctl enable --user this-is-the-sway
systemctl start --user this-is-the-sway

mkdir -p ~/.config/mako/
if [ ! -L "${HOME}/.config/mako/config" ]; then
    rm -R -f "${HOME}/.config/mako/config"
    ln -s "${PROG_DIR}/mako.config" "${HOME}/.config/mako/config"
fi

if [ ! -L "${HOME}/.config/waybar/config.jsonc" ]; then
    rm -R -f "${HOME}/.config/waybar/config.jsonc"
    ln -s "${PROG_DIR}/waybar.jsonc" "${HOME}/.config/waybar/config.jsonc"
fi

if [ ! -L "${HOME}/.config/waybar/style.css" ]; then
    rm -R -f "${HOME}/.config/waybar/style.css"
    ln -s "${PROG_DIR}/waybar.css" "${HOME}/.config/waybar/style.css"
fi

if [ ! -L "${HOME}/.config/waybar/catppuccin-mocha.css" ]; then
    rm -R -f "${HOME}/.config/waybar/catppuccin-mocha.css"
    ln -s "${PROG_DIR}/waybar-catppuccin-mocha.css" "${HOME}/.config/waybar/catppuccin-mocha.css"
fi

# Set firefox catppuccin flamingo theme
firefox https://color.firefox.com/?theme=XQAAAAJHBAAAAAAAAABBqYhm849SCicxcUcPX38oKRicm6da8pFtMcajvXaAE3RJ0F_F447xQs-L1kFlGgDKq4IIvWciiy4upusW7OvXIRinrLrwLvjXB37kvhN5ElayHo02fx3o8RrDShIhRpNiQMOdww5V2sCMLAfehhp8u7kT4nh31-_5sD_P8FhlfX9Sdj_brd9hzw5NA_jx4peTGmoiUcikCHxa8Sm8bylvXElo3HHzylyv8f7R7gwkSEe8Mkq_ERB00vhRYSdLVEI7OR2j9y8UtYJhXmmHxXtQ2a2q0wDt9h-Dv7L5NTOL6rXow07mQCwsiafOlEKwLdkeAd2DoxJ1_Pu_amXOiUhOKrOw2DBrS-cIjSXWu9in58J8EBSEno0b4K2apcsY4mww6HdBAXjQjS7PBl1Eoli3qcNvy3o0v-yq9guO7ozjOWAFY-rVMCACPIWLr-pEBHErXolnftBIiOuC_k1brGAscZ579rDSHW_Bf9KewXOw3subWzfX0sPqI5eJLXKKLKfJEuPnm7z6IlEkCi__KG8k0-VIsE0lvbgk_dPXNsl8__ihao0

# Configure X11 and Wayland cursor
# To bu sure the configuration is also set using
# `gsettings set org.gnome.desktop.interface icon-theme ..` in the sway
# configuration file
mkdir -p ~/.icons/default/
cat > ~/.icons/default/index.theme <<EOF
[icon theme]
Inherits=catppuccin-mocha-flamingo-cursors
EOF


kvantummanager --set "catppuccin-mocha-flamingo"


# Set git behaviour
git config --global commit.verbose true
git config --global core.editor nvim
git config --global rebase.autosquash true
git config --global rerere.enabled true

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
if [ ! -L "${HOME}/.zshrc" ]; then
    rm -R -f "${HOME}/.zshrc"
    ln -s "${PROG_DIR}/zshrc" "${HOME}/.zshrc"
fi
if [ ! -L "${HOME}/.zsh/terminal-title.zsh" ]; then
    rm -R -f "${HOME}/.zsh/terminal-title.zsh"
    ln -s "${PROG_DIR}/terminal-title.zsh" "${HOME}/.zsh/terminal-title.zsh"
fi

chsh -s $(which zsh)

mkdir -p "${HOME}/.config/environment.d/"

if [ ! -L "${HOME}/.config/environment.d/10-paths.conf" ]; then
    ln -s "${PROG_DIR}/environment.d/10-paths.conf" "${HOME}/.config/environment.d/10-paths.conf"
fi

if [ ! -L "${HOME}/.config/environment.d/90-style.conf" ]; then
    ln -s "${PROG_DIR}/environment.d/90-style.conf" "${HOME}/.config/environment.d/90-style.conf"
fi

# Rescan fonts
fc-cache -r -v

mkdir -p "${HOME}/.local/bin/"
cp "${PROG_DIR}/run-hls.sh" "${HOME}/.local/bin/"

cp "${PROG_DIR}/blue.sh" "${HOME}/.local/bin/"

# TODO: keyboard switching
cp "${PROG_DIR}/toggle-keyboard.sh" "${HOME}/.local/bin/"

cp "${PROG_DIR}/screenshot.sh" "${HOME}/.local/bin/"

cp "${PROG_DIR}/powermenu.sh" "${HOME}/.local/bin/"

cp "${PROG_DIR}/background.sh" "${HOME}/.local/bin/"

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
  -g --audio-suspendion     disable audio suspension so there is no poping sound
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
    -g|--audio_suspension)
    AUDIO_SUSPENSION=true
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

if [[ ${AUDIO_SUSPENSION} == true ]]; then
    # Disable audio hardware suspension
    if [ ! -L "${HOME}/.config/wireplumber/wireplumber.conf.d/51-disable-suspension.conf" ]; then
        mkdir -p "${HOME}/.config/wireplumber/wireplumber.conf.d/"
        rm -R -f "${HOME}/.config/wireplumber/wireplumber.conf.d/51-disable-suspension.conf"
        ln -s "${PROG_DIR}/51-disable-suspension.lua" "${HOME}/.config/wireplumber/wireplumber.conf.d/51-disable-suspension.conf"
    fi
    systemctl --user restart pipewire.service
    systemctl --user restart wireplumber.service
fi


if [[ ${SETUP_TELEPORT} == true ]]; then
    setup_teleport
fi

