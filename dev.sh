#!/usr/bin/env bash
# dev.sh — boot a test Awesome session inside a nested Xephyr window.
# Auto-picks the first free display number so we never collide
# with Hyprland's XWayland (which owns :1).
set -eu

for n in 2 3 4 5 6; do
    [ -e /tmp/.X11-unix/X$n ] || { DISP=:$n; break; }
done
[ -n "${DISP:-}" ] || { echo "no free display number"; exit 1; }

Xephyr "$DISP" -resizeable &
XEPHYR_PID=$!
trap 'kill $XEPHYR_PID 2>/dev/null' EXIT   # when awesome exits, window closes too

sleep 1
DISPLAY=$DISP awesome