#!/bin/bash

# Quit all running waybar instances
killall waybar
pkill waybar
sleep 0.5

theme="ml4w-modern"
config_file="config"
style_file="style.css"

waybar \
    -c ~/.config/waybar/themes/$theme/$config_file \
    -s ~/.config/waybar/themes/$theme/$style_file &
