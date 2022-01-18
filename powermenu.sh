#!/usr/bin/env bash

rofi_command="rofi"


# Options
shutdown="⏻  Shutdonw"
reboot="↺  Reboot"
lock="🔒 Lock"
suspend="💤 Suspend"

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n"

chosen="$(echo -e "$options" | $rofi_command -dmenu -font "Iosevka Nerd Font 12" -selected-row 2)"
case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        slock
        ;;
    $suspend)
        systemctl suspend
        ;;
esac
