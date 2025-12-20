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

run_steam_command() {
  local steam_action="$1"

  if [[ "$steam_action" == "open" ]]; then
    local steam_url="steam://open/bigpicture"
    if flatpak list | grep -q 'com.valvesoftware.Steam'; then
      echo "Starting Steam in Big Picture Mode (Flatpak)..."
      flatpak run com.valvesoftware.Steam "$steam_url" &> /dev/null &
    elif command -v steam &> /dev/null; then
      echo "Starting Steam in Big Picture Mode..."
      steam "$steam_url" &> /dev/null &
    fi
  elif [[ "$steam_action" == "shutdown" ]]; then
    if flatpak list | grep -q 'com.valvesoftware.Steam'; then
      echo "Shutting down Steam (Flatpak)..."
      flatpak run com.valvesoftware.Steam -shutdown &> /dev/null
    elif command -v steam &> /dev/null; then
      echo "Shutting down Steam..."
      steam -shutdown &> /dev/null
    fi
  fi
}

AUDIO_SINK=""
STEAM_ACTION=""
case "$PROFILE" in
  desk)
    AUDIO_SINK="$USB_AUDIO_SINK"
    STEAM_ACTION="shutdown"
    ;;
  tv)
    AUDIO_SINK="$HDMI_AUDIO_SINK"
    STEAM_ACTION="open"
    ;;
  all)
    AUDIO_SINK="$USB_AUDIO_SINK"
    STEAM_ACTION="shutdown"
    ;;
esac

echo "Activating profile '$PROFILE'..."
apply_gnome_settings

sleep 1
if [[ -n "$AUDIO_SINK" ]]; then
  echo "Setting audio sink to: $AUDIO_SINK"
  pactl set-default-sink "$AUDIO_SINK"
fi

if [[ -n "$STEAM_ACTION" ]]; then
  run_steam_command "$STEAM_ACTION"
fi

echo "Profile '$PROFILE' successfully activated."