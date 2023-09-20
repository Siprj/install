#!/usr/bin/env bash

LS=$(ls ~/Dropbox/Wallpapers)
declare -a WALLPAPERS
WALLPAPERS=($LS)

while true; do
    random_value=$(od -vAn -N4 -t u4 < /dev/urandom)
    wallpaper=${WALLPAPERS[ $random_value % ${#WALLPAPERS[@]} ]}
    echo $wallpaper
    swaymsg "output * bg Dropbox/Wallpapers/${wallpaper} fill"
    sleep 1800
done
