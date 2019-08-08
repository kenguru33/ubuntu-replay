#!/bin/bash

set -o pipefail
set -o nounset

info="\\e[1;1m"
nc="\\e[0m"

if [[ "${UBUNTU_REPLAY_ONLINE:-}" -eq 1 ]]; then
    # shellcheck source=lib/package.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/package.sh") &>/dev/null
    # shellcheck source=lib/spinner.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/spinner.sh") &>/dev/null
    # shellcheck source=manifest.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/manifest.sh") &>/dev/null
    # shellcheck source=lib/gnome-extension.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/gnome-extension.sh") &>/dev/null
else
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=manifest.sh
    source "${dir}/manifest.sh"
    # shellcheck source=lib/package.sh
    source "${dir}/lib/package.sh"
    # shellcheck source=lib/spinner.sh
    source "${dir}/lib/spinner.sh"
    # shellcheck source=lib/gnome-extension.sh
    source "${dir}/lib/gnome-extension.sh"
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
    gsettings set org.gnome.desktop.background picture-uri "${URI}" &>/dev/null
    # set the desktop lockscreen
    wget "$IMAGE_URL_LOCKSCREEN" -O "$FILE_LOCKSCREEN" &>/dev/null
    URI="file:///${FILE_LOCKSCREEN}"
    gsettings set org.gnome.desktop.screensaver picture-uri "${URI}" &>/dev/null
}

defaultEditor() {
    if [[ ! -z "${DEFAULT_EDITOR:-}" ]]; then
        sudo update-alternatives --set editor "${DEFAULT_EDITOR}"
    fi
}

terminalColor() {
    defaultProfileUUID=""
    defaultProfileUUID=$(gsettings get org.gnome.Terminal.ProfilesList default)
    defaultProfileUUID=${defaultProfileUUID:1:-1}
    dconf write "/org/gnome/terminal/legacy/profiles:/:${defaultProfileUUID}/use-theme-colors" false
}

theme() {
    gsettings set org.gnome.desktop.interface gtk-theme "Yaru-dark"
}

iconSize() {
    gsettings set org.gnome.nautilus.icon-view default-zoom-level 'large'
}

printf "$info%s$nc\\n" "Desktop environment" || exit 1

spinner start "Setting windows buttons to $BUTTON_LAYOUT"
gsettings set org.gnome.desktop.wm.preferences button-layout "${BUTTON_LAYOUT}" &>/dev/null
spinner stop $?
spinner start "Setting touchpad to tap to click..."
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click "$TAP_TO_CLICK" &>/dev/null
spinner stop $?
spinner start "Setting full font hinting and antialiasing for LCS screens..."
gsettings set org.gnome.settings-daemon.plugins.xsettings hinting "$FONT_HINTING" &>/dev/null &&
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing "$FONT_ANTIALIASING" &>/dev/null
spinner stop $?
spinner start "Setting wallpaper..."
wallpaper
spinner stop $?
spinner start "Setting default editor..."
defaultEditor &>/dev/null
spinner stop $?
spinner start "Disabling colors from system theme on terminal..."
terminalColor
spinner stop $?
spinner start "Set theme..."
theme
spinner stop $?
spinner start "Set nautilus icon size"
iconSize
spinner stop $?
