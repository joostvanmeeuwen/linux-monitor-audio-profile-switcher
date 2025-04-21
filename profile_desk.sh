#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_FILE="$SCRIPT_DIR/profile_config.sh"

if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  echo "Error: Configuration file $CONFIG_FILE not found!"
  exit 1
fi

echo "Activating profile: Desk Monitors..."

cmd_args=()

# Monitor 1 settings
cmd_args+=(output."$MONITOR1_ID".enable)
cmd_args+=(output."$MONITOR1_ID".mode."$DESK_M1_MODE")
cmd_args+=(output."$MONITOR1_ID".position."$DESK_M1_POS")
cmd_args+=(output."$MONITOR1_ID".scale."$DESK_M1_SCALE")
if [[ "$DESK_M1_PRIMARY" == "true" ]]; then
  cmd_args+=(output."$MONITOR1_ID".primary)
fi

# Monitor 2 settings
cmd_args+=(output."$MONITOR2_ID".enable)
cmd_args+=(output."$MONITOR2_ID".mode."$DESK_M2_MODE")
cmd_args+=(output."$MONITOR2_ID".position."$DESK_M2_POS")
cmd_args+=(output."$MONITOR2_ID".scale."$DESK_M2_SCALE")
if [[ "$DESK_M2_PRIMARY" == "true" ]]; then
  cmd_args+=(output."$MONITOR2_ID".primary)
fi

# TV settings
cmd_args+=(output."$TV_ID".disable)

kscreen-doctor "${cmd_args[@]}"

sleep 1

echo "Audio sink set to: $USB_AUDIO_SINK"
pactl set-default-sink "$USB_AUDIO_SINK"

echo "Attempting to exit Steam Big Picture Mode (if active)..."
steam steam://close/bigpicture &

echo "Desk Monitors profile activated."
