#!/bin/bash

set -o pipefail
set -o nounset

if [[ "${UBUNTU_REPLAY_ONLINE:-}" -eq 1 ]]; then
    # shellcheck source=lib/package.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/package.sh") &>/dev/null
    # shellcheck source=lib/spinner.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/spinner.sh") &>/dev/null
    # shellcheck source=manifest.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/manifest.sh") &>/dev/null
else
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=manifest.sh
    source "${dir}/manifest.sh"
    # shellcheck source=lib/package.sh
    source "${dir}/lib/package.sh"
    # shellcheck source=lib/spinner.sh
    source "${dir}/lib/spinner.sh"
fi

sudo echo || exit 1

# set data from manifest
packages=( "${PACKAGES[@]}" )
snap_packages=( "${SNAP_PACKAGES[@]}")

# check for required repos here!!! # remove this when manifest is in place
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
