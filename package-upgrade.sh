#!/bin/bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/package.sh
source "${dir}/lib/package.sh"
# shellcheck source=lib/spinner.sh
source "${dir}/lib/spinner.sh"

sudo echo

spinner start "Upgrading all packages..."
packageUpdate &>/dev/null
packageUpgrade &>/dev/null
spinner stop $?

