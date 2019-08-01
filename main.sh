#!/bin/bash

set -o pipefail
#set -o nounset

cleanup() {
    unset UBUNTU_REPLAY_VERSION
    unset UBUNTU_REPLAY_ONLINE
    unset UBUNTU_REPLAY_SRC_URL
    #echo "UBUNTU_REPLAY_VERSION: ${UBUNTU_REPLAY_VERSION}"
    #echo "UBUNTU_REPLAY_ONLINE: ${UBUNTU_REPLAY_ONLINE}"
    #echo "UBUNTU_REPLAY_SRC_URL: ${UBUNTU_REPLAY_SRC}" 
}

trap cleanup EXIT

[[ -z ${UBUNTU_REPLAY_VERSION} ]] && UBUNTU_REPLAY_VERSION="stable"
UBUNTU_REPLAY_ONLINE=1

[[ ${UBUNTU_REPLAY_VERSION} == "stable" ]] && UBUNTU_REPLAY_SRC_URL="https://raw.githubusercontent.com/kenguru33/ubuntu-replay/master"
[[ ${UBUNTU_REPLAY_VERSION} == "develop" ]] && UBUNTU_REPLAY_SRC_URL="https://raw.githubusercontent.com/kenguru33/ubuntu-replay/develop"

export UBUNTU_REPLAY_VERSION
export UBUNTU_REPLAY_ONLINE
export UBUNTU_REPLAY_SRC_URL

echo "Welcome to Ubuntu Replay V1.0"

scripts=(
    "package-repos.sh"
    "package-install.sh"
    "package-remove.sh"
    "package-replace.sh"
    "desktop-environment.sh"
    "shell-environment.sh"
)

if [[ "$UBUNTU_REPLAY_ONLINE" -eq 1 ]]; then
    echo "Running Online Scripts (${UBUNTU_REPLAY_VERSION})"
    for script in "${scripts[@]}"; do 
        wget -qO- "${UBUNTU_REPLAY_SRC_URL}/${script}" | bash -s
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


