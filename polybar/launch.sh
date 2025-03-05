#!/usr/bin/env bash

# Terminating running bars
polybar-msg cmd quit

# Launch polybar on all monitors
if type "xrandr"; then
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
		MONITOR=$m polybar --reload bar &
	done
else
	polybar --reload bar &
fi
