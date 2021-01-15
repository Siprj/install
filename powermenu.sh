#!/usr/bin/env bash

rofi_command="rofi"


# Confirmation
confirm_exit() {
    echo -e "No\nYes" | rofi \
        -p "Are You Sure?" \
        -dmenu -selected-row 2
}

# Options
shutdown=" Shutdonw"
reboot=" Reboot"
lock=" Lock"
suspend=" Suspend"

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
        ans=$(confirm_exit &)
        if [[ $ans == "Yes" ]]; then
            systemctl poweroff
        fi
        ;;
    $reboot)
        ans=$(confirm_exit &)
        if [[ $ans == "Yes" ]]; then
            systemctl reboot
        fi
        ;;
    $lock)
        slock
        ;;
    $suspend)
        ans=$(confirm_exit &)
        if [[ $ans == "Yes" ]]; then
            systemctl suspend
        fi
        ;;
esac
