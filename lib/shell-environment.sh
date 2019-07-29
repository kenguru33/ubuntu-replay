#!/bin/bash
set -o pipefail

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
    sudo npm config set unsafe-perm true &&
    sudo npm install -g pure-prompt &&
    sed -i -e 's/ZSH_THEME=".*"/ZSH_THEME=""/' "${HOME}"/.zshrc &&
    grep -qxF 'autoload -U promptinit; promptinit' "${HOME}"/.zshrc || echo 'autoload -U promptinit; promptinit' >> "${HOME}"/.zshrc &&
    grep -qxF 'prompt pure' "${HOME}"/.zshrc || echo 'prompt pure' >> "${HOME}"/.zshrc
}

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${dir}/spinner.sh"

sudo echo

spinner start "Set default shell..."
setDefaultShell "/usr/bin/zsh" &>/dev/null
spinner stop $?

spinner start "Install zsh framework..."
installZshFramework &>/dev/null &&
installSyntaxHighLighting &>/dev/null
spinner stop $?

spinner start "Install shell prompt..."
installShellPrompt &>/dev/null
spinner stop $?