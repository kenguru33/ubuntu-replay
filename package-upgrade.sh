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

spinner start "Upgrading all packages..."
packageUpdate &>/dev/null
packageUpgrade &>/dev/null
spinner stop $?

