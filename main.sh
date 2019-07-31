#!/bin/bash

set -o pipefail
#set -o nounset

export UBUNTU-REPLAY-VERSION="stable"
export UBUNTU-REPLAY-ONLINE=1
[[ ${UBUNTU-REPLAY_VERSION} == "stable" ]] && export UBUNTU-REPLAY-SRC-URL="https://raw.githubusercontent.com/kenguru33/ubuntu-replay/master"
[[ ${UBUNTU-REPLAY_VERSION} == "stable" ]] && export UBUNTU_REPLAY-SRC-URL="https://raw.githubusercontent.com/kenguru33/ubuntu-replay/develop"

scripts=(
    "package-repos.sh"
    "package-install.sh"
    "package-remove.sh"
    "package-replace.sh"
    "desktop-environment.sh"
    "shell-environment.sh"
)

if [[ "$UBUNTU-REPLAY-ONLINE" -eq 1 ]]; then
    echo "Running Online Scripts"
    for script in "${scripts[@]}"; do 
        wget -qO- "${SRC-URL}/${script}" | bash -s
    done
else
    echo "Running Local scripts"
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=lib/package.sh
    source "${dir}/lib/package.sh"
    # shellcheck source=lib/spinner.sh
    source "${dir}/lib/spinner.sh"
    for script in "${scripts[@]}"; do
        "${dir}/${script}"
    done
fi

