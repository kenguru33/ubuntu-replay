#!/bin/bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${dir}/ubuntu/package.sh"
source "${dir}/spinner.sh"

sudo echo

spinner start "Upgrading all packages..."
packageUpdate &>/dev/null
packageUpgrade &>/dev/null
spinner stop $?

