#!/bin/bash
# 1. Launch Ghostty with a unique title so we can target it
ghostty --title="floating-terminal" &

# 2. Wait and Force
# We loop for a max of 2 seconds (20 tries) until the window is found
for i in {1..20}; do
    # Check if a window with our title exists
    if mmsg -g -c | grep -q "floating-terminal"; then
        mmsg -d set_floating,1
        mmsg -d set_size,725,400
        mmsg -d center
        exit 0
    fi
    sleep 0.05
done
