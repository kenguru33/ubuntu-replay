#!/bin/bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/ubuntu/package.sh
source "${dir}/ubuntu/package.sh"
# shellcheck source=lib/spinner.sh
source "${dir}/spinner.sh"

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

