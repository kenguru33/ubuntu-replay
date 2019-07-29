#!/bin/bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/ubuntu/package.sh
source "${dir}/ubuntu/package.sh"
# shellcheck source=lib/spinner.sh
source "${dir}/spinner.sh"

sudo echo

spinner start "Upgrading all packages..."
packageUpdate &>/dev/null
packageUpgrade &>/dev/null
spinner stop $?

