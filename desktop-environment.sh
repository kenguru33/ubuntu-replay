#!/bin/bash

if [[ "$UBUNTU_REPLAY_ONLINE" -eq 1 ]]; then
    # shellcheck source=lib/package.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/package.sh") &>/dev/null
    # shellcheck source=lib/spinner.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/spinner.sh") &>/dev/null
else
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=lib/package.sh
    source "${dir}/lib/package.sh"
    # shellcheck source=lib/spinner.sh
    source "${dir}/lib/spinner.sh"
fi

sudo echo

spinner start "Setting windows button to close only..."
gsettings set org.gnome.desktop.wm.preferences button-layout ":close"
spinner stop $?
spinner start "Setting touchpad to tap to click..."
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click 'true'
spinner stop $?
spinner start "Setting full font hinting and antialiasing for LCS screens..."
gsettings set org.gnome.settings-daemon.plugins.xsettings hinting 'full' &&
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
spinner stop $?
