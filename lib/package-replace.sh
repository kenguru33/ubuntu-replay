#!/bin/bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/ubuntu/package.sh
source "${dir}/ubuntu/package.sh"
# shellcheck source=lib/spinner.sh
source "${dir}/spinner.sh"

sudo echo

# replace snap packages with native pacage
spinner start "Fetching installed snap packages..."
installed_snap_packages=$(snap list | awk '{if (NR!=1) print $1}') >/dev/null
spinner stop $?
for package in $installed_snap_packages; do
    if [[ $(apt-cache search "$package" | grep -wc "$package") -eq 1 ]]; then
        spinner start "Replacing $package"
        debPackageInstall "$package" &&
        snapPackageRemove "$package"
        spinner stop $?
    fi
done