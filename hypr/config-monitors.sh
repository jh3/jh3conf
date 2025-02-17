#!/bin/bash

# get status of lid
cat /proc/acpi/button/lid/LID0/state # => state:   open | closed

# get status of power cable
# returns 1 when plugged in
# returns 0 when unplugged
cat /sys/class/power_supply/AC/online

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
