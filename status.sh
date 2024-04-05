#!/bin/bash

while true; do
    battery=$(cat /sys/class/power_supply/BAT0/capacity)
    date=$(date +'%A %Y-%m-%d %H:%M:%S %p')
    wifi=$(nmcli -t -f NAME,TYPE connection show --active | grep -E 'wi*' | awk -F: '{ print $1 }')
    volume=$(amixer -D pulse sget Master | grep 'Front Left:' | awk -F'[][]' '{ print $2 }' | sed 's/%//g')
    brightness=$(brightnessctl g)
    ram_used=$(free -kh | grep Mem | awk '{print $3}')
    ram_full=$(free -kh | grep Mem | awk '{print $2}')
    power_used=$(upower -d | grep energy-rate | awk '{print $2}' | head -n1)
    
    # Emoji representations for status indicators
    if [ $battery -gt 20 ]; then
        battery_emoji="🔋"
    else
        battery_emoji="🪫"
    fi

    if [ $volume -gt 70 ]; then
        volume_emoji="🔊"
    elif [ $volume -gt 30 ]; then
        volume_emoji="🔉"
    else
        volume_emoji="🔈"
    fi

    if [ $brightness -gt 200 ]; then
        brightness_emoji="☀️"
    elif [ $brightness -gt 100 ]; then
        brightness_emoji="🌤️"
    else
        brightness_emoji="🌙"
    fi

    power_emoji="⚡"

    echo "📶 SSID: $wifi | $volume_emoji VOL: $volume% | $brightness_emoji BR: $brightness/255 | RAM: $ram_used / $ram_full | $power_emoji $power_used W | $battery_emoji BAT: $battery% | $date"

    sleep 0.2
done
