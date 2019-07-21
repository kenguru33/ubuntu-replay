#!/bin/bash
clear
echo "Welcome to Ubunut Replay V1.0"
sudo echo Starting... 
if [[ $? -eq 1 ]];then
    exit 1;
fi 

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# installing essentials
printf '\e[33m%s\e[m\n' "Installing essential packages:"
packages=(git build-essential vim curl zsh)
for package in "${packages[@]}"; do
    echo -ne "  Installing ${package}..."
    "${dir}"/lib/spin.sh "${dir}"/lib/package.sh -i "$package" 2>/dev/null
    printf '\r%-50s \e[32m%20s\e[m\n' "Installing ${package}" "[OK]"
done

# replace snap packages with native pacage
printf '\e[33m%s\e[m\n' "Replacing snap packages:"
installed_snap_packages=$(snap list | awk '{if (NR!=1) print $1}')

for package in $installed_snap_packages; do
    if [[ $(apt-cache search "$package" | grep -wc "$package") -eq 1 ]]; then 
        echo -ne "  Replacing ${package}..."
        "${dir}"/lib/spin.sh "${dir}"/lib/package.sh -i "$package" 2>/dev/null
        "${dir}"/lib/spin.sh "${dir}"/lib/snap-package.sh -r "$package" 2>/dev/null
        printf '\r%-50s \e[32m%20s\e[m\n' "Replacing ${package}" "[OK]"
    else
        printf '\r%-50s \e[33m%20s\e[m\n' "Replacing ${package}" "[KEEP]"
    fi
done

# remove unwanted ubuntu tweaks
printf '\e[33m%s\e[m\n' "Removing gnome extensions:"
unwanted_packages=(gnome-shell-extension-ubuntu-dock gnome-shell-extension-desktop-icons gnome-shell-extension-appindicator)
for package in "${unwanted_packages[@]}"; do
    echo -ne "  Removing $package..."
    "${dir}"/lib/spin.sh "${dir}"/lib/package.sh -r "$package" 2>/dev/null
    printf '\r%-50s \e[32m%20s\e[m\n' "Removing ${package}" "[OK]"
done

# installing additional packages
printf '\e[33m%s\e[m\n' "Installing additional packages:"
echo -ne "  Adding repositories..."
# vscode repo
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo apt-key add - &>/dev/null 
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
# chrome repo
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - &>/dev/null
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
# nodejs
VERSION=node_10.x # get this live
DISTRO="$(lsb_release -s -c)"
curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - &>/dev/null; 
echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list >/dev/null; 
echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list >/dev/null; 

printf '\r%-50s \e[32m%20s\e[m\n' "Adding repositories" "[OK]"

echo -ne "  Refreshing package repositories..."
"${dir}"/lib/spin.sh "${dir}"/lib/package.sh -u 2>/dev/null
printf '\r%-50s \e[32m%20s\e[m\n' "Refreshing package repositories" "[OK]"

packages=(evolution-ews apt-transport-https code google-chrome-stable gnome-tweaks nodejs)
for package in "${packages[@]}"; do
    echo -ne "  Installing ${package}..."
    "${dir}"/lib/spin.sh "${dir}"/lib/package.sh -i "$package" 2>/dev/null
    printf '\r%-50s \e[32m%20s\e[m\n' "Installing ${package}" "[OK]"
done

snap_packages=(spotify slack)
for package in "${snap_packages[@]}"; do
    echo -ne "  Installing ${package}..."
    "${dir}"/lib/spin.sh "${dir}"/lib/snap-package.sh -i "$package" 2>/dev/null
    printf '\r%-50s \e[32m%20s\e[m\n' "Installing ${package}" "[OK]"
done

# oh-my-zsh
printf '\e[33m%s\e[m\n' "Setting up shell environment:"
echo -ne "  Installing oh-my-zsh..."
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then 
    "${dir}"/lib/spin.sh sh -c "RUNZSH=no $(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &>/dev/null
fi
sudo -S chsh -s '/usr/bin/zsh' "${USER}"
printf '\r%-50s \e[32m%20s\e[m\n' "Installing oh-my-zsh" "[OK]"

# syntax-highligthing
echo -ne "  Installing zsh-syntax-highligthing..."
if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
        "${dir}"/lib/spin.sh git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" &>/dev/null
fi
printf '\r%-50s \e[32m%20s\e[m\n' "Installing zsh-syntax-highlighting" "[OK]"
(sed -i -e 's/plugins=(.*)/plugins=(git zsh-syntax-highlighting)/' "${HOME}"/.zshrc)
# installing pure-prompt
echo -ne "  Installing pure-prompt..."
(sudo npm config set unsafe-perm true)
"${dir}"/lib/spin.sh "${dir}"/lib/npm-package.sh -i "pure-prompt" 2>/dev/null
(sed -i -e 's/ZSH_THEME=".*"/ZSH_THEME=""/' "${HOME}"/.zshrc)
(grep -qxF 'autoload -U promptinit; promptinit' "${HOME}"/.zshrc || echo 'autoload -U promptinit; promptinit' >> "${HOME}"/.zshrc)
(grep -qxF 'prompt pure' "${HOME}"/.zshrc || echo 'prompt pure' >> "${HOME}"/.zshrc)
printf '\r%-50s \e[32m%20s\e[m\n' "Installing pure-prompt" "[OK]"

printf '\e[33m%s\e[m\n' "Configure Gnome:"
echo -ne "  Windows button close only..."
gsettings set org.gnome.desktop.wm.preferences button-layout ":close"
printf '\r%-50s \e[32m%20s\e[m\n' "Windows button close only" "[OK]"
echo -ne "  Touchpad tap to click..."
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click 'true'
printf '\r%-50s \e[32m%20s\e[m\n' "Touchpad tap to click" "[OK]"
echo -ne "  Full font hinting and antialiasing for LCS screens..."
gsettings set org.gnome.settings-daemon.plugins.xsettings hinting 'full'
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
printf '\r%-50s \e[32m%20s\e[m\n' "Full font hinting and antialiasing for LCS screens" "[OK]"

printf '\e[33m%s\e[m\n' "System Update:"
echo -ne "  Running full system update (this will take long time)..."
sudo apt-get upgrade -y >/dev/null
printf '\r%-50s \e[32m%20s\e[m\n' "Running full system update" "[OK]"
printf '\e[33m%s\e[m\n' "System will now reboot..."
sudo reboot
