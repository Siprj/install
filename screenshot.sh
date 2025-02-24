#!/usr/bin/env bash

rofi_command="rofi"

# Options
screenshot_screen_save="Screenshot Screen Save"
screenshot_box_selection_save="Screenshot Box Selection Save"

# Variable passed to rofi
options="$screenshot_screen_save\n$screenshot_box_selection_save\n"

chosen="$(echo -e "$options" | $rofi_command -dmenu -font "FiraCode Nerd Font 12" -selected-row 1)"
case $chosen in
    $screenshot_screen_save)
        flameshot screen
        ;;
    $screenshot_box_selection_save)
        flameshot gui
        ;;
esac
