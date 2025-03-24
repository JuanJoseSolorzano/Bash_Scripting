#!/bin/bash

CURRENT_LAYOUT=$(setxkbmap -query | awk 'NR==3{print $2}')

echo "Your current keyboard layout is: $CURRENT_LAYOUT"

if [[ "$CURRENT_LAYOUT" = "us" || "$CURRENT_LAYOUT" = "es" ]]; then
  # To switch to arabic
    setxkbmap "latam"
    echo "Set: 'latam' keyboard layout"
else
    setxkbmap "es"
fi
