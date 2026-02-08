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

apply_gnome_settings() {
  echo "Applying profile using gdctl..."
  local args=()

  case "$PROFILE" in
    desk)
      args+=(--logical-monitor)
      if [[ "$DESK_M1_PRIMARY" == "true" ]]; then args+=(--primary); fi
      args+=(--monitor "$MONITOR1_ID" --mode "$DESK_M1_MODE" --x "$DESK_M1_POS_X" --y "$DESK_M1_POS_Y" --scale "$DESK_M1_SCALE")

      args+=(--logical-monitor)
      if [[ "$DESK_M2_PRIMARY" == "true" ]]; then args+=(--primary); fi
      args+=(--monitor "$MONITOR2_ID" --mode "$DESK_M2_MODE" --x "$DESK_M2_POS_X" --y "$DESK_M2_POS_Y" --scale "$DESK_M2_SCALE")
      ;;
    tv)
      args+=(--logical-monitor)
      if [[ "$TV_TV_PRIMARY" == "true" ]]; then args+=(--primary); fi
      args+=(--monitor "$TV_ID" --mode "$TV_TV_MODE" --x "$TV_TV_POS_X" --y "$TV_TV_POS_Y" --scale "$TV_TV_SCALE")
      ;;
    all)
      args+=(--logical-monitor)
      if [[ "$ALL_M1_PRIMARY" == "true" ]]; then args+=(--primary); fi
      args+=(--monitor "$MONITOR1_ID" --mode "$ALL_M1_MODE" --x "$ALL_M1_POS_X" --y "$ALL_M1_POS_Y" --scale "$ALL_M1_SCALE")

      args+=(--logical-monitor)
      if [[ "$ALL_M2_PRIMARY" == "true" ]]; then args+=(--primary); fi
      args+=(--monitor "$MONITOR2_ID" --mode "$ALL_M2_MODE" --x "$ALL_M2_POS_X" --y "$ALL_M2_POS_Y" --scale "$ALL_M2_SCALE")

      args+=(--logical-monitor)
      if [[ "$ALL_TV_PRIMARY" == "true" ]]; then args+=(--primary); fi
      args+=(--monitor "$TV_ID" --mode "$ALL_TV_MODE" --x "$ALL_TV_POS_X" --y "$ALL_TV_POS_Y" --scale "$ALL_TV_SCALE")
      ;;
  esac

  gdctl set "${args[@]}"
}

AUDIO_SINK=""
case "$PROFILE" in
  desk) AUDIO_SINK="$USB_AUDIO_SINK" ;;
  tv)   AUDIO_SINK="$HDMI_AUDIO_SINK" ;;
  all)  AUDIO_SINK="$USB_AUDIO_SINK" ;;
esac

echo "Activating profile '$PROFILE'..."
apply_gnome_settings

sleep 1
if [[ -n "$AUDIO_SINK" ]]; then
  echo "Setting audio sink to: $AUDIO_SINK"
  pactl set-default-sink "$AUDIO_SINK"
fi

echo "Profile '$PROFILE' successfully activated."