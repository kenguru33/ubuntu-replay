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
    # shellcheck source=lib/environment-tools.sh
    source <(wget -qO- "${UBUNTU_REPLAY_SRC_URL}/lib/environment-tools.sh") &>/dev/null
else
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=manifest.sh
    source "${dir}/manifest.sh"
    # shellcheck source=lib/package.sh
    source "${dir}/lib/package.sh"
    # shellcheck source=lib/spinner.sh
    source "${dir}/lib/spinner.sh"
    # shellcheck source=lib/environment-tools.sh
    source "${dir}/lib/environment-tools.sh"
fi

setDefaultShell() {
    local defaultShell="${1:-c}"
    sudo -S chsh -s "$defaultShell" "${USER}" 
}

installZshFramework() {
    rm -rf "${HOME}/.oh-my-zsh" &&
    curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s
}

installSyntaxHighLighting() {
    if [[ -d "${HOME}/.oh-my-zsh" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    else
        (exit 1)
    fi
}

installShellPrompt() {
    # sudo npm config set unsafe-perm true &&
    sudo npm install -g pure-prompt &&
    sed -i -e 's/ZSH_THEME=".*"/ZSH_THEME=""/' "${HOME}"/.zshrc &&
    grep -qxF 'autoload -U promptinit; promptinit' "${HOME}"/.zshrc || echo 'autoload -U promptinit; promptinit' >> "${HOME}"/.zshrc &&
    grep -qxF 'prompt pure' "${HOME}"/.zshrc || echo 'prompt pure' >> "${HOME}"/.zshrc
}

setupNpm() {
    # where to place global modules
    npm config set prefix ~/.npm
    addPath "\$HOME/.npm/bin"

}

sudo printf "$info%s$nc\\n" "Shell environment" || exit 1

spinner start "Set default shell..."
setDefaultShell "/usr/bin/zsh" &>/dev/null
spinner stop $?

spinner start "Install zsh framework..."
installZshFramework &>/dev/null &&
installSyntaxHighLighting &>/dev/null
spinner stop $?

spinner start "Configure npm prefix"
setupNpm 
spinner stop $?

spinner start "Install shell prompt..."
installShellPrompt 
spinner stop $?