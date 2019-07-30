#!/bin/bash

set -o pipefail
#set -o nounset

cleanup() {
    unset ONLINE
    unset VERSION
    echo Finsihed! Please log out.
}

scripts=(
    "package-repos.sh"
    "package-install.sh"
    "package-remove.sh"
    "package-replace.sh"
    "desktop-environment.sh"
    "shell-environment.sh"
)

if [[ ${ONLINE:-1} -eq 1 ]]; then
    echo "Running Online Scripts"
    export ONLINE
    export srcUrl="https://raw.githubusercontent.com/kenguru33/ubuntu-replay/${_version:-master}"
    for script in "${scripts[@]}"; do 
        wget -qO- "${srcUrl}/${script}" | bash -s
    done
else
    echo "Running Local scripts"
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=lib/package.sh
    source "${dir}/lib/package.sh"
    # shellcheck source=lib/spinner.sh
    source "${dir}/lib/spinner.sh"
    for script in "${scripts[@]}"; do
        ${dir}/${script}
    done
fi

trap cleanup EXIT
