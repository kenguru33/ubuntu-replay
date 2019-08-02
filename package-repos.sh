#!/bin/bash

set -o pipefail
set -o nounset

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

sudo echo || exit 1

for key in "${!REPO_KEY[@]}"; do
    spinner start "Add repository signing key ${key}..."
    debPackageAddRepoKey "${REPO_KEY["$key"]}" &>/dev/null
    spinner stop $?
done

for repo in "${!REPO_DEB[@]}"; do
    spinner start "Add binary repository for ${repo}..."
    debPackageAddRepo "${REPO_DEB["$repo"]}" "$repo" &>/dev/null
    spinner stop $?
done

for repo in "${!REPO_DEB_SRC[@]}"; do
    spinner start "Add source repository for ${repo}..."
    debPackageAddRepo "${REPO_DEB_SRC["$repo"]}" "$repo" &>/dev/null
    spinner stop $?
done

spinner start "Retrieve new lists of packages..."
debPackageUpdate &>/dev/null
spinner stop $?