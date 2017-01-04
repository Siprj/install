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
packages=(arandr
    asciidoc
    autoconf
    autocutsel
    automake
    ctags
    cups
    deluge
    dia
    dmenu
    evince
    feh
    firefox
    gcc
    git
    graphviz
    hicolor-icon-theme
    keepassx
    konsole
    libxft
    libzip
    lyx
    make
    moc
    nautilus
    networkmanager
    okular
    pkg-config
    pulseaudio
    quassel-monolithic
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
    vlc
    vpnc
    wireshark-gtk
    xautolock
    xorg-xmessage
    )

sudo pacman -Sy
sudo pacman -Sy --needed ${packages[@]}

pacman -Q dropbox || apacman -S --noconfirm dropbox
pacman -Q google-chrome || apacman -S --noconfirm google-chrome
pacman -Q openttd-openmsx || apacman  -S --noconfirm openttd-openmsx
pacman -Q antu-dark-icon-theme-git || apacman  -S --noconfirm antu-dark-icon-theme-git

# I hate nano.
pacman -Q nano &> /dev/null && sudo pacman -R nano

# TODO: install my xmonad configuration

stack install xmobar --flag xmobar:with_alsa

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

xautolock --time 20 --locker slock &

.screenlayout/two-monitors.sh

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

#Set zsh behaviour
ZSHRC="${HOME}/.zshrc"
sed -i "s/ZSH_THEME=\".*\"/ZSH_THEME=\"agnoster\"/g" ${ZSHRC}
sed -i "s/^.*ENABLE_CORRECTION=\".*\"/ENABLE_CORRECTION=\"true\"/g" ${ZSHRC}
sed -i "s/^.*COMPLETION_WAITING_DOTS=\".*\"/COMPLETION_WAITING_DOTS=\"true\"/g" ${ZSHRC}
sed -i "s/^.*UPDATE_ZSH_DAYS=.*/UPDATE_ZSH_DAYS=7/g" ${ZSHRC}
sed -i "s/^.*HIST_STAMPS=.*/HIST_STAMPS=\"mm\/dd\/yyyy\"/g" ${ZSHRC}
