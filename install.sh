#!/bin/bash -xe

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
packages=(arandr
    ark
    asciidoc
    autoconf
    autocutsel
    automake
    bridge-utils
    cairo
    calibre
    ctags
    cups
    deluge
    dia
    dmenu
    dnsmasq
    evince
    feh
    ffmpeg
    firefox
    firewalld
    fontconfig
    fping
    freetype2
    gcc-multilib
    git
    gitg
    gnome-logs
    graphviz
    gwenview
    hicolor-icon-theme
    hunspell
    hunspell-en
    iptables
    jq
    keepassx
    konsole
    lib32-cairo
    lib32-fontconfig
    lib32-freetype2
    libxft
    libzip
    linux-headers
    lyx
    make
    moc
    nautilus
    networkmanager
    network-manager-applet
    nfs-utils
    okular
    openbsd-netcat
    openssh
    oxygen-icons
    oxygen-icons-svg
    pkg-config
    pulseaudio
    qemu
    qt5
    qt5ct
    qt5-doc
    qtcreator
    quassel-client
    rdesktop
    sane
    scrot
    slock
    sox
    stack
    stalonetray
    steam
    teamspeak3
    texlive-core
    texlive-langgreek
    thunderbird
    tree
    unrar
    unzip
    vifm
    virt-manager
    vlc
    vpnc
    wireshark-gtk
    xautolock
    xorg-xev
    xorg-xmessage
    xterm
    zsh
    )

sudo pacman -Sy
sudo pacman -Sy --needed ${packages[@]}

pacman -Q packer || apacmna -S --noconfirm packer
pacman -Q dropbox || packer -S dropbox
pacman -Q google-chrome || packer -S google-chrome
pacman -Q openttd-openmsx || packer  -S openttd-openmsx
pacman -Q powerline-fonts-git || packer  -S powerline-fonts-git
pacman -Q par || packer  -S par
pacman -Q remmina-plugin-rdesktop || packer -S remmina-plugin-rdesktop
pacman -Q xflux || packer -S xflux
pacman -Q feedreader || packer -S feedreader

sudo systemctl enable libvirtd

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

# I hate nano.
pacman -Q nano &> /dev/null && sudo pacman -R nano

# TODO: install my vim configuration

if [ -d ~/xmonadrc ]; then
    (cd ~/xmonadrc && git pull --rebase && stack setup && stack install)
else
    (cd ~/ && git clone https://github.com/Siprj/xmonadrc.git)
    (cd ~/xmonadrc && stack setup && stack install)
fi

(cd ~/xmonadrc && stack install xmobar --flag xmobar:with_alsa)

# setup stalonetray
cat > ~/.stalonetrayrc <<EOF
decorations none
transparent false
dockapp_mode none
geometry 5x1+1460+0
max_geometry 5x1-295-10
background "#000000"
kludges force_icons_size
grow_gravity NE
icon_gravity NE
icon_size 12
sticky true
#window_strut none
window_type dock
window_layer bottom
#no_shrink false
skip_taskbar true
EOF

# setup .xinitrc
cat > ~/.xinitrc <<EOF
# .xsession

xrdb ~/.Xresources

# xsetroot -cursor_name left_ptr

stalonetray &

xautolock -time 20 -locker slock &

.screenlayout/two-monitors.sh

dropbox start -i &

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
if [ ! -n "$ZSH" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Put stack bin path into path
STACK_BIN_PATH="~/.local/bin"
ZPROFILE="${HOME}/.zprofile"
if [ -s "${ZPROFILE}" ]; then
    if grep "${STACK_BIN_PATH}" "${ZPROFILE}"; then
        echo "stack bin path is already persent; see: ${ZPROFILE}"
    else
        echo "path=(~/.local/bin \$path[@])" >> "${ZPROFILE}"
    fi
else
    cat > "${ZPROFILE}" <<EOF
typeset -U path
path=(~/.local/bin \$path[@])
EOF
fi

# Set zsh behaviour
ZSHRC="${HOME}/.zshrc"
sed -i "s/ZSH_THEME=\".*\"/ZSH_THEME=\"agnoster\"/g" ${ZSHRC}
sed -i "s/^.*ENABLE_CORRECTION=\".*\"/ENABLE_CORRECTION=\"true\"/g" ${ZSHRC}
sed -i "s/^.*COMPLETION_WAITING_DOTS=\".*\"/COMPLETION_WAITING_DOTS=\"true\"/g" ${ZSHRC}
sed -i "s/^.*UPDATE_ZSH_DAYS=.*/UPDATE_ZSH_DAYS=7/g" ${ZSHRC}
sed -i "s/^.*HIST_STAMPS=.*/HIST_STAMPS=\"mm\/dd\/yyyy\"/g" ${ZSHRC}

cat > ~/.oh-my-zsh/custom/load-bash-completition.zsh <<EOF
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

source /usr/share/bash-completion/completions/stack
EOF

# Set git behaviour
git config --global commit.verbose true

# Configure konsole
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


cat > ~/.local/share/konsole/my.colorscheme <<EOF
[Background]
Color=0,16,21

[BackgroundFaint]
Color=0,43,54

[BackgroundIntense]
Color=7,54,66

[Color0]
Color=3,28,34

[Color0Faint]
Color=6,48,59

[Color0Intense]
Color=0,43,54

[Color1]
Color=220,50,47

[Color1Faint]
Color=147,33,31

[Color1Intense]
Color=203,75,22

[Color2]
Color=133,153,0

[Color2Faint]
Color=94,106,0

[Color2Intense]
Color=88,110,117

[Color3]
Color=181,137,0

[Color3Faint]
Color=138,103,0

[Color3Intense]
Color=101,123,131

[Color4]
Color=38,139,210

[Color4Faint]
Color=20,77,115

[Color4Intense]
Color=131,148,150

[Color5]
Color=211,54,130

[Color5Faint]
Color=120,30,75

[Color5Intense]
Color=108,113,196

[Color6]
Color=42,161,152

[Color6Faint]
Color=24,94,88

[Color6Intense]
Color=147,161,161

[Color7]
Color=238,232,213

[Color7Faint]
Color=171,167,154

[Color7Intense]
Color=253,246,227

[Foreground]
Color=131,148,150

[ForegroundFaint]
Color=106,119,121

[ForegroundIntense]
Color=147,161,161

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
