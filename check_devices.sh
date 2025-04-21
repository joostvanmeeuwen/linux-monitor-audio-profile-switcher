#!/bin/bash

echo "-----------------------------------------------------"
echo " DISPLAYS (for kscreen-doctor)"
echo "-----------------------------------------------------"
echo "Look for 'Output:' lines (e.g. DP-1, HDMI-A-1) and note the ID."
echo "Also note desired resolutions and refresh rates (e.g. 2560x1440@60)."
echo ""
kscreen-doctor -o
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
echo "Use the information above to verify profile_config.sh
echo "-----------------------------------------------------"
