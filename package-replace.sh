#!/bin/bash

if [[ $ONLINE -eq 1 ]]; then
    # shellcheck source=lib/package.sh
    source <(wget -qO- "${srcUrl}/lib/package.sh") 
    # shellcheck source=lib/spinner.sh
    source <(wget -qO- "${srcUrl}/lib/spinner.sh") 
fi

sudo echo "Online: ${ONLINE}"

# replace snap packages with native pacage
spinner start "Fetching installed snap packages..."
installed_snap_packages=$(snap list | awk '{if (NR!=1) print $1}')
spinner stop $?
for package in $installed_snap_packages; do
    if [[ $(apt-cache search "$package" | grep -wc "$package") -eq 1 ]]; then
        spinner start "Replacing $package"
        debPackageInstall "$package" &&
        snapPackageRemove "$package"
        spinner stop $?
    fi
done