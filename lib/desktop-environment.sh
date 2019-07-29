#!/bin/bash

gnomeDesktop() {
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
}

undo() {
    echo "Not implemented"
}

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${dir}/spinner.sh"


sudo echo

gnomeDesktop