#!/usr/bin/env bash

# Terminating running bars
polybar-msg cmd quit

# Launch polybar
polybar bar 2>&1 | tee a /tmp/polybar1.log & disown

#echo "Bar launched."
