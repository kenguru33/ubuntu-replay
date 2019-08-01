#!/bin/bash

set -o pipefail
set -o nounset

if [[ "$UBUNTU_REPLAY_ONLINE" -eq 1 ]]; then
    # shellcheck source=lib/package.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/package.sh") &>/dev/null
    # shellcheck source=lib/spinner.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/spinner.sh") &>/dev/null
else
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=lib/package.sh
    source "${dir}/lib/package.sh"
    # shellcheck source=lib/spinner.sh
    source "${dir}/lib/spinner.sh"
fi

sudo echo || exit 1


spinner start "Adding VSCode repository..."
    debPackageAddRepoKey "https://packages.microsoft.com/keys/microsoft.asc" &>/dev/null &&
    debPackageAddRepo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" "vscode" &>/dev/null
spinner stop $?

spinner start "Adding Google Chrome repository..."
    debPackageAddRepoKey "https://dl.google.com/linux/linux_signing_key.pub" &>/dev/null &&
    debPackageAddRepo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" "google-chrome" &>/dev/null
spinner stop $?

spinner start "Adding nodesource repository..."
    VERSION=node_10.x # get this live
    DISTRO="$(lsb_release -s -c)"
    debPackageAddRepoKey "https://deb.nodesource.com/gpgkey/nodesource.gpg.key" &>/dev/null &&
    debPackageAddRepo "deb https://deb.nodesource.com/$VERSION $DISTRO main" "nodesource" &>/dev/null &&
    debPackageAddRepo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" "nodesource" &>/dev/null
spinner stop $?

spinner start "Retrieve new lists of packages..."
    debPackageUpdate &>/dev/null
spinner stop $?