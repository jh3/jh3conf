#!/usr/bin/env zsh

# get status of lid
# => state:   open | closed
LID_STATE=$(cat /proc/acpi/button/lid/LID0/state)

# get status of power cable
# returns 1 when plugged in
# returns 0 when unplugged
CHARGING=$(cat /sys/class/power_supply/AC/online)

sleep 1

if [[ "$LID_STATE" =~ "closed" && "$CHARGING" == "1" ]]; then
    echo "LID IS CLOSED AND LAPTOP IS CHARGING"
    if [[ "$(hyprctl monitors)" =~ "\sHDMI-A-[0-9]+" ]]; then
        hyprctl keyword monitor "eDP-1,disable"
        hyprctl keyword monitor "HDMI-A-1,2560x1440@59.95Hz,0x0,1"
    fi
fi

if [[ "$LID_STATE" =~ "open" && "$CHARGING" == "1" ]]; then
    hyprctl keyword monitor "eDP-1,preferred,0x1440,1"
    if [[ "$(hyprctl monitors)" =~ "\sHDMI-A-[0-9]+" ]]; then
        hyprctl keyword monitor "HDMI-A-1,2560x1440@59.95Hz,0x0,1"
    fi
fi

if [[ "$LID_STATE" =~ "open" && "$CHARGING" == "0" ]]; then
    hyprctl keyword monitor "eDP-1,preferred,0x1440,1"
fi

# case 1: (clamshell)
# =======
# if lid is closed
#   AND external monitor is connected
#   AND laptop is plugged in
# the external monitor could go to sleep in this case
# - how to wake it and have it return to the proper configuration?

# case 2: (laptop screen + external monitor)
# =======
# if lid is open
#   AND external monitor is connected
#   AND laptop is plugged in

# case 3: (laptop screen only, while charging)
# =======
# if lid is open
#   AND external monitor is NOT connected
#   AND laptop is plugged in

# case 4: (laptop screen only, while discharging)
# =======
# if lid is open
#   AND external monitor is NOT connected
#   AND laptop is NOT plugged in
