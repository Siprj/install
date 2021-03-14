#!/bin/bash -xe

PROG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

declare SKIP_AUR=false
declare SKIP_PIP=false
declare SKIP_PACMAN=false
declare SKIP_SYSTEM_SETUP=false
declare SKIP_XMONAD=false
declare GPU_ACCELERATION=false
declare DROPBOX=true

function pacman_setp() {
    # Application nmtui is ncurse network manager part of the network-manager package.
    # PDF viewer evince or okular
    # Printer CUPS
    # SANE is scanner app
    # feh can setup wallpaper -- used by xmonad-wallpaper package
    # Bit torrent deluge client.
    # File manager nautilus
    # libasound2-dev for xmobar
    # ubuntu-drivers-common driver installer
    # xautolock can automatically lock computer when no activity
    # scrot is screen capture utility
    # autocutsel synchronize clipboards
    # ss is netstat equivalent
    # network-manager-applet run nm-applet
    # recoll document indexing
    declare -a packages=(
        arandr
        ark
        asciidoc
    #    aspell
    #    aspell-cs
    #    aspell-en
        autoconf
    #    autocutsel
        automake
        bat
        bind-tools
        bluez
        bluez-utils
        bridge-utils
        cairo
        calibre
        cups
        deluge
        dia
    #    dnsmasq
        docker
        dolphin
        dunst
    #    evince
        expac
        feh
        firefox
        firewalld
        fontconfig
        fping
        freetype2
        gcc-multilib
        gdb
        git
        gitg
    #    gnome-logs
        graphviz
        gwenview
        glu
    #    hicolor-icon-theme
        htop
        hunspell
        hunspell-en_GB
        iptables
        jq
        kate
        kdiff3
        konsole
        lib32-cairo
        lib32-fontconfig
        lib32-freetype2
        libreoffice-fresh
        libxft
        libzip
        linux-headers
        lyx
        make
    # Audio player
        moc
        nautilus
        networkmanager
        network-manager-applet
        neovim
        okular
        openbsd-netcat
        openssh
        oxygen-icons
        oxygen-icons-svg
        pavucontrol
        pkg-config
        pulseaudio
        python-neovim
        python-pip
        qemu
        qt5
        qt5ct
        qt5-doc
        qtcreator
        quassel-client
        freerdp
        rdesktop
        recoll
        remmina
        # Application picker instead of dmenu
        rofi
        # Scanner app
        sane
        scrot
        slock
        sox
        steam
        teamspeak3
        texlive-core
        texlive-langgreek
        texlive-latexextra
        thefuck
        thunderbird
        tk
        tree
        unrar
        unzip
        virt-manager
        vlc
        vpnc
        wget
        wireshark-qt
        xautolock
        xorg-xev
        xorg-xmessage
        xsel
        yarn
    #    xterm
        zsh
        )

    sudo pacman -Sy --noconfirm
    sudo pacman -Sy --needed "${packages[@]}" --noconfirm

    # I hate nano.
    pacman -Q nano &> /dev/null && sudo pacman -R nano || true

}

function aur_step () {
    pacman -Q google-chrome || trizen -S google-chrome  --noedit --noconfirm
    pacman -Q libcurl-gnutls || trizen -S libcurl-gnutls --noedit --noconfirm
    # pacman -Q ncurses5-compat-libs || trizen -S ncurses5-compat-libs --noedit --noconfirm
    pacman -Q nerd-fonts-complete || trizen -S nerd-fonts-complete --noedit --noconfirm
    pacman -Q powerline-fonts-git || trizen  -S powerline-fonts-git --noedit --noconfirm
    # pacman -Q spotify || trizen -S spotify --noedit --noconfirm
    pacman -Q trayer-srg || trizen -S trayer-srg --noedit --noconfirm
    pacman -Q universal-ctags-git || trizen -S universal-ctags-git --noedit --noconfirm
    pacman -Q xflux || trizen -S xflux --noedit --noconfirm
    pacman -Q zoom || trizen -S zoom --noedit --noconfirm
    pacman -Q nix-bin || trizen -S nix-bin --noedit --noconfirm
    pacman -Q lazygit || trizen -S lazygit --noedit --noconfirm
}

function pip_setup() {
    if [[ ${DROPBOX} == false ]]; then
        which maestral || pip install --upgrade maestral maestral-qt
    fi
}

function haskell_step () {
    # Bootstrap path
    PATH="${PATH}:${HOME}/.local/bin/:${HOME}/ghcup/bin/"

    which stack || curl -sSL https://get.haskellstack.org/ | sh -s - -d ${HOME}/.local/bin/
    which ghcup || curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    ghcup install ghc "8.10.4"
    ghcup set ghc "8.10.4"
    ghcup install cabal
    ghcup install hls
    cabal update
}

function xmonad_step () {

    if [ -d ~/xmonadrc ]; then
        (cd ~/xmonadrc && git pull --rebase && stack install --install-ghc)
    else
        (cd ~/ && git clone https://github.com/Siprj/xmonadrc.git)
        (cd ~/xmonadrc && stack install)
    fi
    cabal install xmobar --flags=with_alsa --install-method=copy --overwrite-policy=always
}

function system_setup_step() {

sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
sudo systemctl enable nix-daemon
sudo systemctl start nix-daemon

# Disable beep...
sudo bash -c 'cat > /etc/modprobe.d/nobeep.conf <<EOF
blacklist pcspkr
EOF'

# Allow users in libvirt group to access system libvirt
# Add your self to libvirt gropu with
# > gpasswd -a USER_NAME libvirt
sudo bash -c 'cat > /etc/polkit-1/rules.d/50-org.libvirt.unix.manage.rules <<EOF
polkit.addRule(function(action, subject) {
    if (action.id == "org.libvirt.unix.manage" &&
        subject.isInGroup("libvirt")) {
            return polkit.Result.YES;
    }
});
EOF'

sudo usermod --append --groups libvirt `whoami`
sudo usermod --append --groups docker `whoami`


# setup .xinitrc
cat > ~/.xinitrc <<EOF
# .xsession

xrdb ~/.Xresources

# xsetroot -cursor_name left_ptr

trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype percent --width 5 --transparent true --tint 0x000000 --height 17 --monitor primary --alpha 0 &

xautolock -time 20 -locker slock &

.screenlayout/two-monitors.sh

dunst -conf install/dunstrc &

INVOCATION_ID="" maestral start
INVOCATION_ID="" dropbox &

xflux -l 49 -g 15

export XDG_CURRENT_DESKTOP="qt5ct"
export QT_QPA_PLATFORMTHEME="qt5ct"

exec xmonad
EOF

cat > ~/.Xresources <<EOF
! {{{ xmessage

xmessage*form.okay.shapeStyle: rectangle
xmessage*form.okay.background: black
xmessage*form.okay.foreground: rgb:e/b/b
xmessage*message*background: black
xmessage*background: black
xmessage*foreground: gray85
xmessage*Scrollbar.width: 1
xmessage*Scrollbar.borderWidth: 0
xmessage*Text.?.cursorColor: rgb:d/5/5
xmessage*Text.borderColor: gray65
xmessage*Text*background: gray95
xmessage*Command.highlightThickness: 2
xmessage*Command.internalWidth: 5
xmessage*Command.internalHeight: 3
xmessage*Command.borderColor: gray40
xmessage*Command.shapeStyle: Rectangle
xmessage*Command.background: gray90
Xmessage*international: true

! }}} xmessage

! {{{ terminal colors

xterm*bellIsUrgent: true
xterm*background: #001419
xterm*foreground: #b4cbcc
! xterm*font:     *-fixed-*-*-*-18-*
xterm*faceName: Droid Sans Mono for Powerline
xterm*faceSize: 12

*color0:  #04222a
*color1:  #dc322f
*color2:  #cde300
*color3:  #b58900
*color4:  #268bd2
*color5:  #d33682
*color6:  #2aa198
*color7:  #eee8d5
*color8:  #002b36
*color9:  #cb4b16
*color10:  #aaff00
*color11:  #657b83
*color12:  #839496
*color13:  #6c71c4
*color14:  #93a1a1
*color15:  #fdf6e3
*color16:  #06303b
*color17:  #93211f
*color18:  #5e6a00
*color19:  #8a6700
*color20:  #144d73
*color21:  #781e4b
*color22:  #185e58

! }}} terminal colors

EOF

# install oh-my-zsh
if [ -d "~/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Put stack bin path into path
cat > ~/.zprofile <<EOF
typeset -U path
path+=(~/.local/bin)
path+=(~/.ghcup/bin)
path+=(~/.cabal/bin)
path+=(~/.cargo/bin)
EOF

# Set zsh behaviour
ZSHRC="${HOME}/.zshrc"
sed -i "s/ZSH_THEME=\".*\"/ZSH_THEME=\"agnoster-nix\"/g" "${ZSHRC}"
sed -i "s/^.*ENABLE_CORRECTION=\".*\"/ENABLE_CORRECTION=\"true\"/g" "${ZSHRC}"
sed -i "s/^.*COMPLETION_WAITING_DOTS=\".*\"/COMPLETION_WAITING_DOTS=\"true\"/g" "${ZSHRC}"
sed -i "s/^.*UPDATE_ZSH_DAYS=.*/UPDATE_ZSH_DAYS=7/g" "${ZSHRC}"
sed -i "s/^.*HIST_STAMPS=.*/HIST_STAMPS=\"mm\\/dd\\/yyyy\"/g" "${ZSHRC}"
sed -i "s/^.*plugins=.*/plugins=(git thefuck nix-shell)/g" "${ZSHRC}"

cat > ~/.oh-my-zsh/custom/custom-rc.zsh <<EOF
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

alias vim="~/.local/bin/nvim"
EDITOR=nvim
EOF

if [ -d ~/.oh-my-zsh/plugins/nix-shell ]; then
    (cd ~/.oh-my-zsh/plugins/nix-shell && git pull --rebase)
else
  git clone https://github.com/chisui/zsh-nix-shell.git ~/.oh-my-zsh/plugins/nix-shell
fi

cp ${PROG_DIR}/agnoster-nix.zsh-theme ~/.oh-my-zsh/custom/themes
mkdir -p ~/.config/rofi/ && cp ${PROG_DIR}/rofi.rasi ~/.config/rofi/config.rasi

# Set git behaviour
git config --global commit.verbose true
git config --global core.editor nvim
git config --global rebase.autosquash true

# Configure konsole
mkdir -p ~/.config/
cat > ~/.config/konsolerc <<EOF
[Desktop Entry]
DefaultProfile=Profile1.profile

[Favorite Profiles]
Favorites=Profile1.profile

[KonsoleWindow]
ShowMenuBarByDefault=false
ShowWindowTitleOnTitleBar=true

[MainWindow]
Height 1050=1048
Height 1080=1061
MenuBar=Disabled
State=AAAA/wAAAAD9AAAAAAAAB34AAAQlAAAABAAAAAQAAAAIAAAACPwAAAAA
ToolBarsMovable=Disabled
Width 1680=838
Width 1920=1918

[TabBar]
TabBarVisibility=ShowTabBarWhenNeeded
EOF


mkdir -p ~/.local/share/konsole
cat > ~/.local/share/konsole/my.colorscheme <<EOF
[Background]
Color=0,0,0

[BackgroundFaint]
Color=0,0,0

[BackgroundIntense]
Color=0,0,0

[Color0]
Color=3,28,34

[Color0Faint]
Color=24,24,24

[Color0Intense]
Color=104,104,104

[Color1]
Color=250,75,75

[Color1Faint]
Color=101,25,25

[Color1Intense]
Color=255,84,84

[Color2]
Color=133,153,0

[Color2Faint]
Color=0,101,0

[Color2Intense]
Color=84,255,84

[Color3]
Color=181,138,34

[Color3Faint]
Color=101,74,0

[Color3Intense]
Color=255,255,84

[Color4]
Color=38,139,210

[Color4Faint]
Color=0,0,101

[Color4Intense]
Color=84,84,255

[Color5]
Color=225,30,225

[Color5Faint]
Color=95,5,95

[Color5Intense]
Color=255,84,255

[Color6]
Color=24,178,178

[Color6Faint]
Color=0,101,101

[Color6Intense]
Color=84,255,255

[Color7]
Color=178,178,178

[Color7Faint]
Color=101,101,101

[Color7Intense]
Color=255,255,255

[Foreground]
Color=131,148,150

[ForegroundFaint]
Color=18,200,18

[ForegroundIntense]
Color=24,240,24

[General]
Description=my
Opacity=1
Wallpaper=
EOF

cat > ~/.local/share/konsole/Profile1.profile <<EOF
[Appearance]
BoldIntense=true
ColorScheme=my
Font=Droid Sans Mono Dotted for Powerline,12,-1,5,50,0,0,0,0,0
UseFontLineChararacters=false

[General]
Name=Profile1
Parent=FALLBACK/
EOF

# Instal vim-plug and configure vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.config/
if [ -d "~/.config/nvim/" ]; then
    ln -s "${PROG_DIR}/nvim" ~/.config/nvim
fi
nvim -u ~/.config/nvim/init.vim +PlugUpgrade +PlugUpdate +PlugClean! +qall

cp "${PROG_DIR}/run-hls.sh" "${HOME}/.local/bin"

mkdir -p ~/.config/jesseduffield/lazygit/
cat > ~/.config/jesseduffield/lazygit/config.yml <<EOF
  gui:
    theme:
      selectedLineBgColor:
        - reverse
EOF

# Set default applications

xdg-mime default org.kde.dolphin.desktop inode/directory
xdg-mime default org.kde.okular.desktop application/pdf
xdg-mime default firefox.desktop x-scheme-handler/http
xdg-mime default firefox.desktop x-scheme-handler/https
}

function print_help() {
cat << EOF
Usage: install.sh [OPTION]

  -p --skip-pacman          don't install/update standard arch packages
  -a --skip-aur             don't install/update packages form AUR
  -i --skip-pip             don't install packages with pip
  -x --skip-xmonad          don't install/update xmonad
  -s --skip-system-setup    don't try to setup system setup
  -g --gpu-acceleration     sett GPU acceleration method to legacy mode
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
    -i|--skip-pip)
    SKIP_PIP=true
    shift # past argument
    ;;
    -m|--maestral)
    DROPBOX=false
    shift # past argument
    ;;
    -x|--skip-xmonad)
    SKIP_XMONAD=true
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
if [[ ${SKIP_PIP} == false ]]; then
    pip_setup
fi
if [[ ${SKIP_XMONAD} == false ]]; then
    haskell_step
fi
if [[ ${SKIP_XMONAD} == false ]]; then
    xmonad_step
fi
if [[ ${SKIP_SYSTEM_SETUP} == false ]]; then
    system_setup_step
fi

if [[ ${GPU_ACCELERATION} == true ]]; then
    sudo mkdir -p "/etc/X11/xorg.conf.d/"
    sudo cp "${PROG_DIR}/20-amdgpu.conf" "/etc/X11/xorg.conf.d/"
    sudo cp "${PROG_DIR}/20-intell.conf" "/etc/X11/xorg.conf.d/"
fi
