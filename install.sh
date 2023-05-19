#!/bin/bash -xe

PROG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

declare SKIP_AUR=false
declare SKIP_PIP=false
declare SKIP_PACMAN=false
declare SKIP_SYSTEM_SETUP=false
declare SKIP_RUST=false
declare GPU_ACCELERATION=false
declare SETUP_TELEPORT=false
declare SKIP_FONTS=false

function pacman_setp() {
    # Application nmtui is ncurse network manager part of the network-manager package.
    # PDF viewer evince or okular
    # Printer CUPS
    # SANE is scanner app
    # Bit torrent deluge client.
    # File manager nautilus
    # ubuntu-drivers-common driver installer
    # scrot is screen capture utility
    # autocutsel synchronize clipboards
    # ss is netstat equivalent
    # network-manager-applet run nm-applet
    # recoll document indexing
    declare -a packages=(
        arandr
        alacritty
        autoconf
        automake
        bat
        bluez
        bluez-utils
        bridge-utils
        calibre
        cups
        docker
        docker-buildx

        #file manager and supporting packages
        thunar
        gvfs
        gvfs-smb

        # Desktop notifications
        dunst
        feh
        firefox

        # firewall
        ufw

        fontconfig
        freetype2
        gcc-multilib
        gdb
        git
        git-lfs
        github-cli
        graphviz
        gwenview
        ghidra
        btop
        hunspell
        hunspell-en_GB
        jq
        kate
        libreoffice-fresh
        make
        systemd-resolvconf
        networkmanager
        network-manager-applet
        neovim
        okular
        openssh
        pavucontrol
        pkgconf
        pulseaudio
        freerdp
        rdesktop
        recoll
        remmina
        rustup
        # Application picker instead of dmenu
        rofi
        # Scanner app
        sane
        scrot
        slock
        steam
        teamspeak3
        texlive-core
        texlive-langgreek
        texlive-latexextra
        thefuck
        thunderbird
        tree
        unrar
        unzip
        vlc
        wget
        wireshark-qt
        zsh
        tealdeer
        zk
        redshift
        krita
        gnome-keyring
        seahorse
        element-desktop
        i3-wm
        xss-lock
        )

    sudo pacman -Sy --noconfirm
    sudo pacman -Sy --needed "${packages[@]}"

    # I hate nano.
    pacman -Q nano &> /dev/null && sudo pacman -Rscun nano || true
    # I don't want to use trizen any more
    pacman -Q trizen &> /dev/null && sudo pacman -Rscun trizen || true

    # Try to enable pacman colors
    sudo sed -i "s/#Color/Color/" "/etc/pacman.conf"
}

function install_paru () {
    mkdir -p "${HOME}/dev/"
    ( cd "${HOME}/dev/" &&
        git clone https://aur.archlinux.org/paru.git &&
        cd paru &&
        makepkg -si
    )
}

function aur_step () {
    pacman -Q paru || install_paru
    pacman -Q google-chrome || paru -S google-chrome --noconfirm
    pacman -Q spotify || paru -S spotify --noconfirm
    pacman -Q zoom || paru -S zoom --noconfirm
    pacman -Q lazygit || paru -S lazygit --noconfirm
    pacman -Q polybar-git || paru -S polybar-git --noconfirm
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

function system_setup_step() {

sudo systemctl daemon-reload

# Firewall setup
sudo systemctl enable ufw.service
sudo systemctl start ufw.service

sudo ufw default deny
sudo ufw enable

sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
sudo systemctl enable systemd-resolved.service
sudo systemctl start systemd-resolved.service

# Disable beep...
sudo bash -c 'cat > /etc/modprobe.d/nobeep.conf <<EOF
blacklist pcspkr
EOF'

sudo usermod --append --groups docker `whoami`


# setup .xinitrc
cat > ~/.xinitrc <<EOF
# .xsession
run-parts --verbose --regex="\.sh" /etc/X11/xinit/xinitrc.d/

gnome-keyring-daemon --components=secrets --daemonize --start

.screenlayout/two-monitors.sh

exec i3
EOF

# install oh-my-zsh
if [ -d "~/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Put stack, ghcup, cargo, cabal bin paths into path
cat > ~/.zprofile <<EOF
typeset -U path
path+=(~/.local/bin)
path+=(~/.ghcup/bin)
path+=(~/.cabal/bin)
path+=(~/.cargo/bin)
EOF

# Set zsh behaviour
ZSHRC="${HOME}/.zshrc"
sed -i "s/ZSH_THEME=\".*\"/ZSH_THEME=\"agnoster\"/g" "${ZSHRC}"
sed -i "s/^.*ENABLE_CORRECTION=\".*\"/ENABLE_CORRECTION=\"true\"/g" "${ZSHRC}"
sed -i "s/^.*COMPLETION_WAITING_DOTS=\".*\"/COMPLETION_WAITING_DOTS=\"true\"/g" "${ZSHRC}"
sed -i "s/^.*UPDATE_ZSH_DAYS=.*/UPDATE_ZSH_DAYS=7/g" "${ZSHRC}"
sed -i "s/^.*HIST_STAMPS=.*/HIST_STAMPS=\"mm\\/dd\\/yyyy\"/g" "${ZSHRC}"
sed -i "s/^.*plugins=.*/plugins=(git thefuck)/g" "${ZSHRC}"

cat > ~/.oh-my-zsh/custom/custom-rc.zsh <<EOF
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

alias vim="nvim"
export EDITOR=nvim
export ZK_NOTEBOOK_DIR=${HOME}/Dropbox/notes
export TERMINFO='/usr/share/terminfo/'
alias hx="helix"
EOF


mkdir -p ~/.config/rofi/ && cp ${PROG_DIR}/rofi.rasi ~/.config/rofi/config.rasi

# Set git behaviour
git config --global commit.verbose true
git config --global core.editor nvim
git config --global rebase.autosquash true

mkdir -p ~/.config/
if [ ! -L "${HOME}/.config/nvim" ]; then
    ln -s "${PROG_DIR}/nvim" ~/.config/nvim
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

# Install polybar configuration
mkdir -p "${HOME}/.config/polybar"
rm -f "${HOME}/.config/polybar/config"
cp "${PROG_DIR}/polybar.conf" "${HOME}/.config/polybar/config.ini"

# Install alacritty configuration
if [ ! -L "${HOME}/.config/alacritty" ]; then
    ln -s "${PROG_DIR}/alacritty" ~/.config/alacritty
fi

# Set default applications

xdg-mime default thunar.desktop inode/directory
xdg-mime default org.kde.okular.desktop application/pdf
xdg-mime default firefox.desktop x-scheme-handler/http
xdg-mime default firefox.desktop x-scheme-handler/https

# Configure mouse acceleration....
# https://wiki.archlinux.org/title/Mouse_acceleration
if [[ ! -f "/etc/X11/xorg.conf.d/50-mouse-acceleration.conf" ]]; then
    sudo cp "${PROG_DIR}/50-mouse-acceleration.conf" /etc/X11/xorg.conf.d/50-mouse-acceleration.conf
fi

# Configure i3
mkdir -p "${HOME}/.config/i3"
cp "${PROG_DIR}/i3.config" "${HOME}/.config/i3/config"

# Rescan fonts
fc-cache -r -v

cp "${PROG_DIR}/run-hls.sh" "${HOME}/.local/bin/"

cp "${PROG_DIR}/blue.sh" "${HOME}/.local/bin/"

cp "${PROG_DIR}/toggle-keyboard.sh" "${HOME}/.local/bin/"

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

function print_help() {
cat << EOF
Usage: install.sh [OPTION]

  -p --skip-pacman          don't install/update standard arch packages
  -a --skip-aur             don't install/update packages form AUR
  -i --skip-pip             don't install packages with pip
  -f --skip-fonts           don't install fonts
  -r --skip-rust            don't install/update rust tool chain
  -s --skip-system-setup    don't try to setup system setup
  -g --gpu-acceleration     set GPU acceleration method to legacy mode
  -t --teleport             configure this machine as teleport node
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
    -s|--skip-system-setup)
    SKIP_SYSTEM_SETUP=true
    shift # past argument
    ;;
    -g|--gpu-acceleration)
    GPU_ACCELERATION=true
    shift # past argument
    ;;
    -t|--teleport)
    SETUP_TELEPORT=true
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
if [[ ${SKIP_AUR} == false ]]; then
    aur_step
fi
if [[ ${SKIP_FONTS} == false ]]; then
    font_step
fi
if [[ ${SKIP_RUST} == false ]]; then
    rust_step
fi
if [[ ${SKIP_SYSTEM_SETUP} == false ]]; then
    system_setup_step
fi

if [[ ${GPU_ACCELERATION} == true ]]; then
    sudo mkdir -p "/etc/X11/xorg.conf.d/"
    sudo cp "${PROG_DIR}/20-amdgpu.conf" "/etc/X11/xorg.conf.d/"
    sudo cp "${PROG_DIR}/20-intell.conf" "/etc/X11/xorg.conf.d/"
fi

if [[ ${SETUP_TELEPORT} == true ]]; then
    setup_teleport
fi

