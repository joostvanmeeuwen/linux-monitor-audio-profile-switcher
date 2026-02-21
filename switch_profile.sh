#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_FILE="$SCRIPT_DIR/profile_config.sh"

if [[ -z "$1" || ! "$1" =~ ^(desk|tv|all)$ ]]; then
  echo "Usage: $0 [desk|tv|all]"
  exit 1
fi
PROFILE="$1"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Configuration file $CONFIG_FILE not found!"
  exit 1
fi
source "$CONFIG_FILE"

echo "Activating profile '$PROFILE'..."

case "$PROFILE" in
  desk)
    gdctl set \
      --logical-monitor --primary \
        --monitor "$MONITOR1_ID" --mode "$DESK_M1_MODE" \
        --x "$DESK_M1_POS_X" --y "$DESK_M1_POS_Y" --scale "$DESK_M1_SCALE" \
      --logical-monitor \
        --monitor "$MONITOR2_ID" --mode "$DESK_M2_MODE" \
        --x "$DESK_M2_POS_X" --y "$DESK_M2_POS_Y" --scale "$DESK_M2_SCALE"
    sleep 1
    pactl set-default-sink "$USB_AUDIO_SINK"
    ;;
  tv)
    gdctl set \
      --logical-monitor --primary \
        --monitor "$TV_ID" --mode "$TV_TV_MODE" \
        --x "$TV_TV_POS_X" --y "$TV_TV_POS_Y" --scale "$TV_TV_SCALE"
    sleep 1
    pactl set-default-sink "$HDMI_AUDIO_SINK"
    ;;
  all)
    gdctl set \
      --logical-monitor --primary \
        --monitor "$MONITOR1_ID" --mode "$ALL_M1_MODE" \
        --x "$ALL_M1_POS_X" --y "$ALL_M1_POS_Y" --scale "$ALL_M1_SCALE" \
      --logical-monitor \
        --monitor "$MONITOR2_ID" --mode "$ALL_M2_MODE" \
        --x "$ALL_M2_POS_X" --y "$ALL_M2_POS_Y" --scale "$ALL_M2_SCALE" \
      --logical-monitor \
        --monitor "$TV_ID" --mode "$ALL_TV_MODE" \
        --x "$ALL_TV_POS_X" --y "$ALL_TV_POS_Y" --scale "$ALL_TV_SCALE"
    sleep 1
    pactl set-default-sink "$USB_AUDIO_SINK"
    ;;
esac

echo "Profile '$PROFILE' successfully activated."
