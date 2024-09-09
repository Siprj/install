#!/usr/bin/env bash

rofi_command="rofi"

# Options
screenshot_screen_save="Screenshot Screen Save"
screenshot_screen_upload="Screenshot Screen Upload"
screenshot_selection_save="Screenshot Selection Save"
screenshot_selection_upload="Screenshot Selection Upload"

# Variable passed to rofi
options="$screenshot_screen_save\n$screenshot_screen_upload\n$screenshot_selection_save\n$screenshot_selection_upload\n$logout\n"

chosen="$(echo -e "$options" | $rofi_command -dmenu -font "FiraCode Nerd Font 12" -selected-row 2)"
case $chosen in
    $screenshot_screen_save)
        grimshot save output - | swappy -f - && [[ $(wl-paste -l) == "image/png" ]] && notify-send "Screenshot copied to clipboard"
        ;;
    $screenshot_screen_upload)
        grimshot save output - | swappy -f - -o - | curl -s -F "file=@-;filename=.png" https://x0.at/ | tee >(wl-copy) >(xargs notify-send)
        ;;
    $screenshot_selection_save)
        grimshot save window - | swappy -f - && [[ $(wl-paste -l) == "image/png" ]] && notify-send "Screenshot copied to clipboard"
        ;;
    $screenshot_selection_upload)
        grimshot save window - | swappy -f - -o - | curl -s -F "file=@-;filename=.png" https://x0.at/ | tee >(wl-copy) >(xargs notify-send)
        ;;
esac
