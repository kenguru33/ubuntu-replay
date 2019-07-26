#!/bin/bash
clear
echo -e "WELCOME TO UBUNTU REPLAY V1.0\\n"
sudo echo

if [[ $? -eq 1 ]];then
    exit 1;
fi

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${dir}/lib/spinner.sh"
source "${dir}/lib/colors.sh"

packages=(
    git
    build-essential
    vim
    curl
    zsh
    nodejs
    google-chrome-stable
    code
    evolution-ews
    apt-transport-https
    gnome-tweaks
)

snap_packages=(
    spotify
    slack
)

unwanted_packages=(
    gnome-shell-extension-ubuntu-dock
    gnome-shell-extension-desktop-icons
    gnome-shell-extension-appindicator
)

add_repos() {
    # install vscode repository
    spinner start "Adding VSCode repository..."
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc 2>/dev/null | sudo apt-key add - &>/dev/null &&
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list &>/dev/null
    spinner stop $?
    
    # chrome repo
    spinner start "Adding Google Chrome repository..."
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub 2>/dev/null | sudo apt-key add - &>/dev/null &&
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list &>/dev/null
    spinner stop $?
    
    # nodejs repo
    spinner start "Adding nodesource repository..."
    VERSION=node_10.x # get this live
    DISTRO="$(lsb_release -s -c)"
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key 2>/dev/null | sudo apt-key add - &>/dev/null &&
    echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list &>/dev/null &&
    echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list &>/dev/null
    spinner stop $?
}

upgrade_system() {
    # upgrading system
    spinner start 'Updating system packages...'
    sudo apt-get update &>/dev/null
    spinner stop $?
    spinner start 'Upgrading system packages...'
    sudo apt-get upgrade -y &>/dev/null
    spinner stop $?
}

install_packages() {
    # install packages
    for package in "${packages[@]}"; do
        spinner start "Installing ${package}..."
        sudo apt-get install -y "$package" &>/dev/null
        spinner stop $?
    done
    # install snap packeages
    for package in "${snap_packages[@]}"; do
        spinner start "Installing ${package}... (snap)"
        if [[ "$(snap search "$package" | awk '{print $1 " : "  $4}' | grep -w classic | grep -c "$package ")" -eq 1 ]]; then
            sudo snap install --classic "$package" &>/dev/null
        else
            sudo snap install "$package" &>/dev/null
        fi
        spinner stop $?
    done
}

replace_snap_packages() {
    # replace snap packages with native pacage
    spinner start "Fetching installed snap packages..."
    installed_snap_packages=$(snap list | awk '{if (NR!=1) print $1}') &>/dev/null
    spinner stop $?
    for package in $installed_snap_packages; do
        if [[ $(apt-cache search "$package" | grep -wc "$package") -eq 1 ]]; then
            spinner start "Replacing $package"
            sudo apt-get install -y "$package" &>/dev/null &&
            sudo snap remove "$package" &>/dev/null
            spinner stop $?
        fi
    done
}


remove_unwanted_packages() {
    # remove unwated packages
    for package in "${unwanted_packages[@]}"; do
        spinner start "Removing $package..."
        sudo apt-get --purge remove -y "$package" &>/dev/null
        spinner stop $?
    done
}

shell_environment() {
    # oh-my-zsh
    spinner start "Installing oh-my-zsh..."
    (if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
        sh -c "RUNZSH=no $(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &>/dev/null
    fi) &&
    sudo -S chsh -s '/usr/bin/zsh' "${USER}" &>/dev/null
    spinner stop $?    
    
    # syntax-highligthing
    spinner start "Installing zsh-syntax-highligthing..."
    (if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" &>/dev/null
    fi) &&
    sed -i -e 's/plugins=(.*)/plugins=(git zsh-syntax-highlighting)/' "${HOME}"/.zshrc
    spinner stop $?
    # installing pure-prompt
    spinner start "Installing pure-prompt..."
    sudo npm config set unsafe-perm true &>/dev/null &&
    sudo npm install -g pure-prompt &>/dev/null &&
    sed -i -e 's/ZSH_THEME=".*"/ZSH_THEME=""/' "${HOME}"/.zshrc &&
    grep -qxF 'autoload -U promptinit; promptinit' "${HOME}"/.zshrc || echo 'autoload -U promptinit; promptinit' >> "${HOME}"/.zshrc &&
    grep -qxF 'prompt pure' "${HOME}"/.zshrc || echo 'prompt pure' >> "${HOME}"/.zshrc &&
    spinner stop $?    
}

gnome_desktop() {
    spinner start "Setting windows button to close only..."
    gsettings set org.gnome.desktop.wm.preferences button-layout ":close"
    spinner stop $?
    spinner start "Setting touchpad to tap to click..."
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click 'true'
    spinner stop $?
    spinner start "Setting full font hinting and antialiasing for LCS screens..."
    gsettings set org.gnome.settings-daemon.plugins.xsettings hinting 'full' &&
    gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
    spinner stop $?
}

echo -e "${orange}# Add external repositories:${nc}"
add_repos
echo -e "${orange}# Refreshing systmem:${nc}"
upgrade_system
echo -e "${orange}# Installing packages:${nc}"
install_packages
echo -e "${orange}# Replacing snap packages:${nc}"
replace_snap_packages
echo -e "${orange}# Removing Gnome shell extensions:${nc}"
remove_unwanted_packages
echo -e "${orange}# Setup shell environment for ${USER}:${nc}"
shell_environment
echo -e "${orange}# Configure Gnome Desktop for ${USER}:${nc}"
gnome_desktop

