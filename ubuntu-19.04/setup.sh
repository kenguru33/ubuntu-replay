#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# essential tools
sudo $DIR/PackageInstall.sh git
sudo $DIR/PackageInstall.sh curl
sudo $DIR/PackageInstall.sh zsh
sudo $DIR/PackageInstall.sh vim

# nodejs
curl -sL https://deb.nodesource.com/setup_12.x &>/dev/null | sudo -E bash -
sudo $DIR/PackageInstall.sh nodejs

# remove unwanted ubuntu tweaks
sudo $DIR/PackageRemove.sh gnome-shell-extension-ubuntu-dock
sudo $DIR/PackageRemove.sh gnome-shell-extension-desktop-icons
sudo $DIR/PackageRemove.sh gnome-shell-extension-appindicator

# remove snap packages and replace them with native ones
sudo $DIR/SnapPackageRemove.sh gnome-calculator
sudo $DIR/SnapPackageRemove.sh gnome-calculator 
sudo $DIR/SnapPackageRemove.sh gnome-logs 
sudo $DIR/SnapPackageRemove.sh gnome-system-monitor
sudo $DIR/PackageInstall.sh gnome-calculator
sudo $DIR/PackageInstall.sh gnome-calculator
sudo $DIR/PackageInstall.sh gnome-logs 
sudo $DIR/PackageInstall.sh gnome-system-monitor

# Better terminal prompt
sudo $DIR/NpmPackageInstall.sh pure-prompt

# Setup zsh
$DIR/ZshSetup.sh

# install mail client with support for o365
sudo $DIR/PackageInstall.sh evolution-ews

# TDODO
# install vscode - own repo
# install chrome - own repo
# install gitkraken - own repo
# install spotify - snap package
# sound input out chooser extension

echo "Ubuntu 19.04 has been replayed!"