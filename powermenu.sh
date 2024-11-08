#!/usr/bin/env bash

rofi_command="rofi"


# Options
shutdown="襤 Shutdown"
reboot="↺ Reboot"
lock="  Lock"
suspend="鈴 Suspend"
logout=" Logout"



# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout\n"

chosen="$(echo -e "$options" | $rofi_command -dmenu -font "FiraCode Nerd Font 12" -selected-row 2 --no-case-sensitive)"
case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        loginctl lock-session
        ;;
    $suspend)
        systemctl suspend
        ;;
    $logout)
        loginctl kill-session self
        ;;
esac
