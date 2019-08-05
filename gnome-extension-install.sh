#!/bin/bash

set -o pipefail
set -o nounset

if [[ "${UBUNTU_REPLAY_ONLINE:-}" -eq 1 ]]; then
    # shellcheck source=lib/spinner.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/spinner.sh") &>/dev/null
    # shellcheck source=manifest.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/manifest.sh") &>/dev/null
    # shellcheck source=lib/gnome-extension.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/gnome-extension.sh") &>/dev/null
else
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=manifest.sh
    source "${dir}/manifest.sh"
    # shellcheck source=lib/package.sh
    source "${dir}/lib/spinner.sh"
    # shellcheck source=lib/gnome-extension.sh
    source "${dir}/lib/gnome-extension.sh"
fi

gnomeExtensionInstall () {
    local uuid="$1"
    descFile=$(fetchDescriptionFileByUUID "$uuid") &&
    url=$(extensionUrl "$descFile") &&
    zipFile=$(fetchZipFile "$url") &&
    extensionInstall "$uuid" "$zipFile" && 
    extensionEnable "$uuid" &>/dev/null
}


for extension in "${GNOME_EXTENSIONS[@]}"; do 
  spinner start "Installing extension ${extension}"
  gnomeExtensionInstall "$extension"
  spinner stop $?
done


