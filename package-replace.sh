#!/bin/bash

set -o pipefail
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

sudo echo || exit 1

# replace snap packages with native pacage
spinner start "Fetching installed snap packages..."
installed_snap_packages=$(snap list | awk '{if (NR!=1) print $1}')
spinner stop $?
for package in $installed_snap_packages; do
    if [[ $(apt-cache search "$package" | grep -wc "$package") -eq 1 ]]; then
        spinner start "Replacing $package"
        debPackageInstall "$package" &>/dev/null &&
        snapPackageRemove "$package" &>/dev/null
        spinner stop $?
    fi
done