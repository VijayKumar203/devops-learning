#!/bin/bash

#DATE=$(date)

START_TIME=$(date +%s)

sleep 3     # Foreground The script freezes and waits for 3 seconds before moving to the next line of code.
sleep 8 &  # Background The script immediately continues running the next lines of code while the 10-second timer ticks quietly in the background.
END_TIME=$(date +%s)

TOTAL_TIME=$(($END_TIME-$START_TIME))

echo "Script executed in: $TOTAL_TIME Seconds"

# How to run this file
# sh 04-timestamp.sh
