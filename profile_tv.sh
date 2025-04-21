#!/bin/bash

CONFIG_FILE=./profile_config.sh

if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  echo "Error: Configuration file $CONFIG_FILE not found!"
  exit 1
fi

echo "Activating profile: TV..."

cmd_args=()

# Monitor 1 settings
cmd_args+=(output."$MONITOR1_ID".disable)

# Monitor 2 settings
cmd_args+=(output."$MONITOR2_ID".disable)

# TV settings
cmd_args+=(output."$TV_ID".enable)
cmd_args+=(output."$TV_ID".mode."$TV_MODE")
cmd_args+=(output."$TV_ID".position."$TV_POS")
cmd_args+=(output."$TV_ID".scale."$TV_SCALE")
if [[ "$TV_PRIMARY" == "true" ]]; then
  cmd_args+=(output."$TV_ID".primary)
fi

kscreen-doctor "${cmd_args[@]}"

sleep 1

echo "Audio sink set to: $HDMI_AUDIO_SINK"
pactl set-default-sink "$HDMI_AUDIO_SINK"

echo "TV profile activated."
