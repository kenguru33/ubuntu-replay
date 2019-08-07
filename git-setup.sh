#!/bin/bash

set -o pipefail
set -o nounset

info="\\e[1;1m"
nc="\\e[0m"

if [[ "${UBUNTU_REPLAY_ONLINE:-}" -eq 1 ]]; then
    # shellcheck source=lib/package.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/package.sh") &>/dev/null
    # shellcheck source=lib/spinner.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/spinner.sh") &>/dev/null
    # shellcheck source=manifest.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/manifest.sh") &>/dev/null
else
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=manifest.sh
    source "${dir}/manifest.sh"
    # shellcheck source=lib/package.sh
    source "${dir}/lib/package.sh"
    # shellcheck source=lib/spinner.sh
    source "${dir}/lib/spinner.sh"
fi

configureGit() {
    # Configure libsecret
    (cd /usr/share/doc/git/contrib/credential/libsecret&& sudo make) &&
    git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
}

sudo printf "$info%s$nc\\n" "Git setup" || exit 1
spinner start "Configure git credential helper..."
configureGit &>/dev/null
spinner stop $?