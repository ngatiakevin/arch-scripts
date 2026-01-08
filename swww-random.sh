#!/bin/bash

WALLDIR="$HOME/Pictures/Wallpapers"
INTERVAL=900

if ! pgrep -x swww-daemon >/dev/null; then
    swww-daemon &
    sleep 1.2
fi

while true; do
    WALL=$(find "$WALLDIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)
    [ -z "$WALL" ] && sleep "$INTERVAL" && continue

    swww img "$WALL" \
        --resize crop \
        --transition-type fade \
        --transition-duration 0.9 \
        --transition-fps 30

    wal -n -q -i "$WALL" >/dev/null 2>&1

    # Hot-reload Waybar (no kill)

    sleep "$INTERVAL"
done
