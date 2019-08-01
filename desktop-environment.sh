#!/bin/bash

set -o pipefail
set -o errexit
set -o nounset

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

wallpaper() {
    local IMAGE_URL_DESKTOP="https://unsplash.com/photos/PwzISwC2kLs/download?force=true"
    local IMAGE_URL_LOCKSCREEN="https://unsplash.com/photos/z1x7Pq1Bxbg/download?force=true"
    local WALLPAPER_DIRECTORY="${HOME}/.wallpaper"
    local FILE_DESKTOP="${WALLPAPER_DIRECTORY}/wallpaper.jpg"    
    local FILE_LOCKSCREEN="${WALLPAPER_DIRECTORY}/lockscreen.jpg"
    if [[ ! -d "$WALLPAPER_DIRECTORY" ]]; then
        mkdir "$WALLPAPER_DIRECTORY"
    fi
    wget "$IMAGE_URL_DESKTOP" -O "$FILE_DESKTOP" &>/dev/null
    # set the desktop background
    URI="file:///${FILE_DESKTOP}"
    gsettings set org.gnome.desktop.background picture-uri "${URI}"
    # set the desktop lockscreen
    wget "$IMAGE_URL_LOCKSCREEN" -O "$FILE_LOCKSCREEN" &>/dev/null
    URI="file:///${FILE_LOCKSCREEN}"
    gsettings set org.gnome.desktop.screensaver picture-uri "${URI}"
}

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
spinner start "Set wallpaper..."
wallpaper
spinner stop $?