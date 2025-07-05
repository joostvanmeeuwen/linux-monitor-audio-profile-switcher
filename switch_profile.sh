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

apply_kde_settings() {
  echo "Applying profile using kscreen-doctor (KDE)..."
  local args=()

  case "$PROFILE" in
    desk)
      args+=(output."$MONITOR1_ID".enable output."$MONITOR1_ID".mode."$DESK_M1_MODE" output."$MONITOR1_ID".position."$DESK_M1_POS_X,$DESK_M1_POS_Y" output."$MONITOR1_ID".scale."$DESK_M1_SCALE")
      if [[ "$DESK_M1_PRIMARY" == "true" ]]; then args+=(output."$MONITOR1_ID".primary); fi
      args+=(output."$MONITOR2_ID".enable output."$MONITOR2_ID".mode."$DESK_M2_MODE" output."$MONITOR2_ID".position."$DESK_M2_POS_X,$DESK_M2_POS_Y" output."$MONITOR2_ID".scale."$DESK_M2_SCALE")
      if [[ "$DESK_M2_PRIMARY" == "true" ]]; then args+=(output."$MONITOR2_ID".primary); fi
      args+=(output."$TV_ID".disable)
      ;;
    tv)
      args+=(output."$MONITOR1_ID".disable)
      args+=(output."$MONITOR2_ID".disable)
      args+=(output."$TV_ID".enable output."$TV_ID".mode."$TV_TV_MODE" output."$TV_ID".position."$TV_TV_POS_X,$TV_TV_POS_Y" output."$TV_ID".scale."$TV_TV_SCALE")
      if [[ "$TV_TV_PRIMARY" == "true" ]]; then args+=(output."$TV_ID".primary); fi
      ;;
    all)
      args+=(output."$MONITOR1_ID".enable output."$MONITOR1_ID".mode."$ALL_M1_MODE" output."$MONITOR1_ID".position."$ALL_M1_POS_X,$ALL_M1_POS_Y" output."$MONITOR1_ID".scale."$ALL_M1_SCALE")
      if [[ "$ALL_M1_PRIMARY" == "true" ]]; then args+=(output."$MONITOR1_ID".primary); fi
      args+=(output."$MONITOR2_ID".enable output."$MONITOR2_ID".mode."$ALL_M2_MODE" output."$MONITOR2_ID".position."$ALL_M2_POS_X,$ALL_M2_POS_Y" output."$MONITOR2_ID".scale."$ALL_M2_SCALE")
      if [[ "$ALL_M2_PRIMARY" == "true" ]]; then args+=(output."$MONITOR2_ID".primary); fi
      args+=(output."$TV_ID".enable output."$TV_ID".mode."$ALL_TV_MODE" output."$TV_ID".position."$ALL_TV_POS_X,$ALL_TV_POS_Y" output."$TV_ID".scale."$ALL_TV_SCALE")
      if [[ "$ALL_TV_PRIMARY" == "true" ]]; then args+=(output."$TV_ID".primary); fi
      ;;
  esac

  kscreen-doctor "${args[@]}"
}

apply_gnome_settings() {
  echo "Applying profile using gdctl (GNOME)..."
  local args=()
  local profile_prefix="${PROFILE^^}"

  # Monitor 1
  local m1_enabled_var="${profile_prefix}_M1_ENABLED"
  if [[ "${!m1_enabled_var}" == "true" ]]; then
      local m1_primary_var="${profile_prefix}_M1_PRIMARY"
      local m1_mode_var="${profile_prefix}_M1_MODE"
      local m1_pos_x_var="${profile_prefix}_M1_POS_X"
      local m1_pos_y_var="${profile_prefix}_M1_POS_Y"
      local m1_scale_var="${profile_prefix}_M1_SCALE"

      args+=(--logical-monitor)
      if [[ "${!m1_primary_var}" == "true" ]]; then args+=(--primary); fi
      args+=(--monitor "$MONITOR1_ID" --mode "${!m1_mode_var}" --x "${!m1_pos_x_var}" --y "${!m1_pos_y_var}" --scale "${!m1_scale_var}")
  fi

  # Monitor 2
  local m2_enabled_var="${profile_prefix}_M2_ENABLED"
  if [[ "${!m2_enabled_var}" == "true" ]]; then
      local m2_primary_var="${profile_prefix}_M2_PRIMARY"
      local m2_mode_var="${profile_prefix}_M2_MODE"
      local m2_pos_x_var="${profile_prefix}_M2_POS_X"
      local m2_pos_y_var="${profile_prefix}_M2_POS_Y"
      local m2_scale_var="${profile_prefix}_M2_SCALE"

      args+=(--logical-monitor)
      if [[ "${!m2_primary_var}" == "true" ]]; then args+=(--primary); fi
      args+=(--monitor "$MONITOR2_ID" --mode "${!m2_mode_var}" --x "${!m2_pos_x_var}" --y "${!m2_pos_y_var}" --scale "${!m2_scale_var}")
  fi

  # TV
  local tv_enabled_var="${profile_prefix}_TV_ENABLED"
  if [[ "${!tv_enabled_var}" == "true" ]]; then
      local tv_primary_var="${profile_prefix}_TV_PRIMARY"
      local tv_mode_var="${profile_prefix}_TV_MODE"
      local tv_pos_x_var="${profile_prefix}_TV_POS_X"
      local tv_pos_y_var="${profile_prefix}_TV_POS_Y"
      local tv_scale_var="${profile_prefix}_TV_SCALE"

      args+=(--logical-monitor)
      if [[ "${!tv_primary_var}" == "true" ]]; then args+=(--primary); fi
      args+=(--monitor "$TV_ID" --mode "${!tv_mode_var}" --x "${!tv_pos_x_var}" --y "${!tv_pos_y_var}" --scale "${!tv_scale_var}")
  fi

  if [ ${#args[@]} -gt 0 ]; then
    gdctl set "${args[@]}"
  else
    echo "No monitors to configure for this profile."
  fi
}

run_steam_command() {
  local steam_action="$1"
  local steam_url="steam://${steam_action}/bigpicture"

  if flatpak list | grep -q 'com.valvesoftware.Steam'; then
    echo "Steam (Flatpak) detected. Executing command..."
    flatpak run com.valvesoftware.Steam "$steam_url" &> /dev/null &
  elif command -v steam &> /dev/null; then
    echo "Steam (native) detected. Executing command..."
    steam "$steam_url" &> /dev/null &
  else
    echo "Warning: Steam installation not found."
  fi
}

AUDIO_SINK=""
STEAM_ACTION=""
case "$PROFILE" in
  desk)
    AUDIO_SINK="$USB_AUDIO_SINK"
    STEAM_ACTION="close"
    ;;
  tv)
    AUDIO_SINK="$HDMI_AUDIO_SINK"
    STEAM_ACTION="open"
    ;;
  all)
    AUDIO_SINK="$USB_AUDIO_SINK"
    STEAM_ACTION="close"
    ;;
esac

DE=${XDG_CURRENT_DESKTOP}
echo "Activating profile '$PROFILE' on $DE..."
if [[ "$DE" == "KDE" ]]; then
  apply_kde_settings
elif [[ "$DE" == "GNOME" ]]; then
  apply_gnome_settings
else
  echo "Error: Unknown or unsupported desktop environment: $DE"
  exit 1
fi

sleep 1
if [[ -n "$AUDIO_SINK" ]]; then
  echo "Setting audio sink to: $AUDIO_SINK"
  pactl set-default-sink "$AUDIO_SINK"
fi

if [[ -n "$STEAM_ACTION" ]]; then
  run_steam_command "$STEAM_ACTION"
fi

echo "Profile '$PROFILE' successfully activated."