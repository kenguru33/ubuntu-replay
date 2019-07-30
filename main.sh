#!/bin/bash

set -o pipefail
#set -o nounset

export ONLINE=1

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"${dir}/package-repos.sh"
"${dir}/package-install.sh"
"${dir}/package-remove.sh"
"${dir}/package-replace.sh"
"${dir}/desktop-environment.sh"
"${dir}/shell-environment.sh"






