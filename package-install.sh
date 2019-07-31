#!/bin/bash

if [[ "$UBUNTU-REPLAY-ONLINE" -eq 1 ]]; then
    # shellcheck source=lib/package.sh
    source <(wget -qO- "${UBUNTU-REPLAY-SRC-URL}/lib/package.sh") &>/dev/null
    # shellcheck source=lib/spinner.sh
    source <(wget -qO- "${UBUNTU-REPLAY-SRC-URL}/lib/spinner.sh") &>/dev/null
else
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=lib/package.sh
    source "${dir}/lib/package.sh"
    # shellcheck source=lib/spinner.sh
    source "${dir}/lib/spinner.sh"
fi

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

# check for required repos here!!!
if ! debPackageRepoIsRegistered "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"; then 
    echo "Required repos not registered. Run package-repos.sh to add them."
    exit 1
fi

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
