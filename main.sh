#!/bin/bash

set -o pipefail
#set -o nounset


dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"${dir}/lib/package-install.sh"

"${dir}/lib/package-remove.sh"
"${dir}/lib/package-replace.sh"
"${dir}/lib/desktop-environment.sh"
"${dir}/lib/shell-environment.sh"






