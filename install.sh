#!/bin/bash -xe

PROG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

declare SKIP_AUR=false
declare SKIP_PIP=false
declare SKIP_PACMAN=false
declare SKIP_SYSTEM_SETUP=false
declare SKIP_RUST=false
declare SKIP_RUST_TOOLS=false
declare AUDIO_SUSPENSION=false
declare SKIP_FONTS=false
declare INSTALL_TUXEDO=false


function make_link() {
    FROM="$1"
    TO="$2"
    if [ ! -L "${TO}" ]; then
        rm -R -f "${TO}"
    else
        rm "${TO}"
    fi

    ln -s "${FROM}" "${TO}"
}

function list_directory() {
    DIR="$1"
    ( cd "${DIR}"
        for filename in *; do
            echo "${filename}" 
        done
    )
}

function link_directory() {
    SRC_DIR="$1"
    TARGET_DIR="$2"

    for filename in `list_directory "${SRC_DIR}"`; do
        make_link "${SRC_DIR}/${filename}" "${TARGET_DIR}${filename}"
    done
}

function pacman_setp() {
    declare -a packages=(
        base-devel
        cmake
        cups
        docker
        docker-buildx
        neovim
        gdb
        git
        git-lfs
        github-cli
        graphviz
        ghidra
        hunspell
        hunspell-en_GB
        jq
        libreoffice-fresh
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
        unzip
        vlc
        wget
        wireshark-qt
        tealdeer
        zk
        krita
        element-desktop
        yaml-language-server
        ripgrep
        taplo-cli
        zoxide
        fd
        wireplumber
        pavucontrol
        lua-language-server
        gvfs-smb
        thunar
        xdg-desktop-portal-gtk
        bind
        tree-sitter
        tree-sitter-cli
        zsh
        nwg-look
        swayosd
        brightnessctl
        hyprland
        hypridle
        hyprlock
        hyprpolkitagent
        wpaperd
        qt5ct
        qt5-wayland
        qt6ct
        qt6-wayland
        # kvantum
        xarchiver
        transmission-gtk
        swaync
        gwenview
        wl-clipboard
        firefox
        libappindicator
        nwg-displays
        man-db
        man-pages
        )

    sudo pacman -Sy --noconfirm
    sudo pacman -Sy --needed "${packages[@]}"

    # Try to enable pacman colors
    sudo sed -i "s/#Color/Color/" "/etc/pacman.conf"

    (pacman -Q network-manager-applet && sudo pacman -Rscu network-manager-applet --noconfirm) || true
}

function aur_step () {
    pacman -Q paru || (cd $(mktmp -d); git clone https://aur.archlinux.org/paru.git; cd paru; makepkg -si)
    pacman -Q ashell || paru -S ashell --noconfirm
    pacman -Q spotify || paru -S spotify --noconfirm
    pacman -Q lazygit || paru -S lazygit --noconfirm
    pacman -Q dropbox || paru -S dropbox --noconfirm
    pacman -Q sweet-folders-icons-git || paru -S sweet-folders-icons-git --noconfirm
    pacman -Q catppuccin-sddm-theme-mocha || paru -S catppuccin-sddm-theme-mocha --noconfirm
    # pacman -Q papirus-folders-catppuccin-git || paru -S papirus-folders-catppuccin-git --noconfirm
    pacman -Q colloid-catppuccin-gtk-theme-git || paru -S colloid-catppuccin-gtk-theme-git --noconfirm
    pacman -Q catppuccin-cursors-mocha || paru -S catppuccin-cursors-mocha --noconfirm
    # pacman -Q kvantum-theme-catppuccin-git || paru -S kvantum-theme-catppuccin-git --noconfirm
    pacman -Q vicinae || paru -S vicinae --noconfirm
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
    true
}

function system_setup_step() {

link_directory "${PROG_DIR}/config" "${HOME}/.config/"
link_directory "${PROG_DIR}/dotfiles" "${HOME}/."

sudo mkdir -p /etc/sddm.conf.d/
sudo cp "${PROG_DIR}/sddm.theme" /etc/sddm.conf.d/theme.conf

sudo systemctl daemon-reload

sudo systemctl start systemd-resolved.service
sudo systemctl enable systemd-resolved.service

systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now swaync.service

sudo usermod --append --groups docker `whoami`

# Install oh-my-posh
if [[ ! -f "${HOME}/.local/bin/oh-my-posh" ]]; then
    mkdir -p  "${HOME}/.local/bin/"
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
fi

#mkdir -p ~/.config/sway/config.d/
#if [ ! -L "${HOME}/.config/sway/config.d/outputs.config" ]; then
#
#    rm -R -f "${HOME}/.config/sway/config.d/outputs.config"
#
#    OPTIONS=("Three screens"
#             "One screen")
#
#    select option in "${OPTIONS[@]}"
#    do
#        case $option in
#            "Three screens")
#                ln -s "${PROG_DIR}/sway-three-outputs.config" "${HOME}/.config/sway/config.d/outputs.config"
#                break
#                ;;
#            "One screen")
#                ln -s "${PROG_DIR}/sway-one-outputs.config" "${HOME}/.config/sway/config.d/outputs.config"
#                break
#                ;;
#        esac
#    done
#
#fi

# Set firefox catppuccin flamingo theme
firefox https://color.firefox.com/?theme=XQAAAAJHBAAAAAAAAABBqYhm849SCicxcUcPX38oKRicm6da8pFtMcajvXaAE3RJ0F_F447xQs-L1kFlGgDKq4IIvWciiy4upusW7OvXIRinrLrwLvjXB37kvhN5ElayHo02fx3o8RrDShIhRpNiQMOdww5V2sCMLAfehhp8u7kT4nh31-_5sD_P8FhlfX9Sdj_brd9hzw5NA_jx4peTGmoiUcikCHxa8Sm8bylvXElo3HHzylyv8f7R7gwkSEe8Mkq_ERB00vhRYSdLVEI7OR2j9y8UtYJhXmmHxXtQ2a2q0wDt9h-Dv7L5NTOL6rXow07mQCwsiafOlEKwLdkeAd2DoxJ1_Pu_amXOiUhOKrOw2DBrS-cIjSXWu9in58J8EBSEno0b4K2apcsY4mww6HdBAXjQjS7PBl1Eoli3qcNvy3o0v-yq9guO7ozjOWAFY-rVMCACPIWLr-pEBHErXolnftBIiOuC_k1brGAscZ579rDSHW_Bf9KewXOw3subWzfX0sPqI5eJLXKKLKfJEuPnm7z6IlEkCi__KG8k0-VIsE0lvbgk_dPXNsl8__ihao0

# Set git behaviour
git config --global commit.verbose true
git config --global core.editor nvim
git config --global rebase.autosquash true
git config --global rerere.enabled true

nvim +Lazy

chsh -s $(which zsh)

# Rescan fonts
fc-cache -r -v

mkdir -p "${HOME}/.local/bin/"
cp "${PROG_DIR}/run-hls.sh" "${HOME}/.local/bin/"

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
