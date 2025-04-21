#!/bin/bash

CONFIG_FILE=./profile_config.sh

if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  echo "Error: Configuration file $CONFIG_FILE not found!"
  exit 1
fi

echo "Activating profile: All Displays..."

cmd_args=()

# Monitor 1 settings
cmd_args+=(output."$MONITOR1_ID".enable)
cmd_args+=(output."$MONITOR1_ID".mode."$ALL_M1_MODE")
cmd_args+=(output."$MONITOR1_ID".position."$ALL_M1_POS")
cmd_args+=(output."$MONITOR1_ID".scale."$ALL_M1_SCALE")
if [[ "$ALL_M1_PRIMARY" == "true" ]]; then
  cmd_args+=(output."$MONITOR1_ID".primary)
fi

# Monitor 2 settings
cmd_args+=(output."$MONITOR2_ID".enable)
cmd_args+=(output."$MONITOR2_ID".mode."$ALL_M2_MODE")
cmd_args+=(output."$MONITOR2_ID".position."$ALL_M2_POS")
cmd_args+=(output."$MONITOR2_ID".scale."$ALL_M2_SCALE")
if [[ "$ALL_M2_PRIMARY" == "true" ]]; then
  cmd_args+=(output."$MONITOR2_ID".primary)
fi

# TV settings
cmd_args+=(output."$TV_ID".enable)
cmd_args+=(output."$TV_ID".mode."$ALL_TV_MODE")
cmd_args+=(output."$TV_ID".position."$ALL_TV_POS")
cmd_args+=(output."$TV_ID".scale."$ALL_TV_SCALE")
if [[ "$ALL_TV_PRIMARY" == "true" ]]; then
  cmd_args+=(output."$TV_ID".primary)
fi

kscreen-doctor "${cmd_args[@]}"

sleep 1

echo "Audio sink set to: $HDMI_AUDIO_SINK"
pactl set-default-sink "$HDMI_AUDIO_SINK"

echo "All Displays profile activated."
