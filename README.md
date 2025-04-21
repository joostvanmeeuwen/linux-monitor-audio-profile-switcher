# kde-monitor-audio-profile-switcher

Bash scripts to switch display (monitor/TV) and audio output profiles in KDE Plasma (Wayland, tested on 6.3). Uses `kscreen-doctor` and `pactl`.

## Scripts Included

* `check_devices.sh`: Helper script to find device IDs/names needed for `profile_config.sh`.
* `profile_config.sh`: Configuration file
* `profile_desk.sh`: Activates desk monitors + USB audio.
* `profile_tv.sh`: Activates TV + HDMI audio (with specific scaling).
* `profile_all.sh`: Activates all displays + HDMI audio.

## Basic Setup

1.  Run `./check_devices.sh` to find display IDs and audio sink names.
2.  Edit `profile_config.sh` with the correct values for your hardware and desired settings.
3.  Make scripts executable: `chmod +x *.sh`
4.  Test each profile script manually (e.g., `./profile_desk.sh`).
5.  Assign keyboard shortcuts via KDE System Settings > Keyboard > Shortcuts > Custom Shortcuts.
