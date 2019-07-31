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

unwanted_packages=(
    gnome-shell-extension-ubuntu-dock
    gnome-shell-extension-desktop-icons
    gnome-shell-extension-appindicator
)

for package in "${unwanted_packages[@]}"; do
    spinner start "Removing $package..."
    debPackageRemove "$package" &>/dev/null
    spinner stop $?
done

