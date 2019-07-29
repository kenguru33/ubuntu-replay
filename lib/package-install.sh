#!/bin/bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/ubuntu/package.sh
source "${dir}/ubuntu/package.sh"
# shellcheck source=lib/spinner.sh
source "${dir}/spinner.sh"

"${dir}/package-repos.sh"

sudo echo

packages=(
    git
    build-essential
    vim
    curl
    zsh
    nodejs
    google-chrome-stable
    code
    evolution-ews
    apt-transport-https
    gnome-tweaks
)

snap_packages=(
    spotify
    slack
)

# install deb packages
declare -i n=0
number_of_packages=$((${#packages[@]} + ${#snap_packages[@]}))
for package in "${packages[@]}"; do
    n=$n+1
    spinner start "Installing ${package}... (${n}/${number_of_packages})"
    debPackageInstall "$package" &>/dev/null
    spinner stop $?
done
# install snap packeages
for package in "${snap_packages[@]}"; do
    n=$n+1
    spinner start "Installing ${package}... (${n}/${number_of_packages})"
    snapPackageInstall "$package" &>/dev/null
    spinner stop $?
done
