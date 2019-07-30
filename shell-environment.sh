#!/bin/bash

if [[ $ONLINE -eq 1 ]]; then
    # shellcheck source=lib/package.sh
    source <(wget -qO- "${srcUrl}/lib/package.sh") &>/dev/null
    # shellcheck source=lib/spinner.sh
    source <(wget -qO- "${srcUrl}/lib/spinner.sh") &>/dev/null
else
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=lib/package.sh
    source "${dir}/lib/package.sh"
    # shellcheck source=lib/spinner.sh
    source "${dir}/lib/spinner.sh"
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
    sudo npm config set unsafe-perm true &&
    sudo npm install -g pure-prompt &&
    sed -i -e 's/ZSH_THEME=".*"/ZSH_THEME=""/' "${HOME}"/.zshrc &&
    grep -qxF 'autoload -U promptinit; promptinit' "${HOME}"/.zshrc || echo 'autoload -U promptinit; promptinit' >> "${HOME}"/.zshrc &&
    grep -qxF 'prompt pure' "${HOME}"/.zshrc || echo 'prompt pure' >> "${HOME}"/.zshrc
}

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