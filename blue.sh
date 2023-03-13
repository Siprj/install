#!/usr/bin/env bash

systemctl restart bluetooth.service
bluetoothctl --timeout 5 power on

chosen=($(bluetoothctl devices | rofi -dmenu -font "FiraCode Nerd Font 12" -selected-row 2))

echo ${chosen}

bluetoothctl connect ${chosen[1]}
