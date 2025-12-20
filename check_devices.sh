#!/bin/bash

echo "-----------------------------------------------------"
echo " DISPLAYS"
echo "-----------------------------------------------------"
echo "Use connector names (e.g. DP-1) and modes."
echo ""
gdctl show --modes

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