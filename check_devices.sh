#!/bin/bash

DE=${XDG_CURRENT_DESKTOP}

echo "-----------------------------------------------------"
echo " DISPLAYS"
echo "-----------------------------------------------------"

if [[ "$DE" == "KDE" ]]; then
  echo "Running on KDE. Use 'Output:' IDs (e.g. DP-1) and modes."
  echo ""
  kscreen-doctor -o
elif [[ "$DE" == "GNOME" ]]; then
  echo "Running on GNOME. Use connector names (e.g. DP-1) and modes."
  echo ""
  gdctl show --modes
else
  echo "Warning: Unknown desktop environment. Trying both tools..."
  echo "--- kscreen-doctor (for KDE) ---"
  command -v kscreen-doctor &> /dev/null && kscreen-doctor -o
  echo "--- gdctl (for GNOME) ---"
  command -v gdctl &> /dev/null && gdctl show --modes
fi

echo ""
echo "-----------------------------------------------------"
echo " AUDIO SINKS (for pactl set-default-sink)"
echo "-----------------------------------------------------"
echo "Find the full name of your USB speakers and HDMI output."
echo "(e.g. alsa_output.usb-..., alsa_output.pci-...hdmi-stereo...)"
echo ""
pactl list sinks short
echo ""
echo "-----------------------------------------------------"
echo "Use the information above to verify profile_config.sh"
echo "-----------------------------------------------------"