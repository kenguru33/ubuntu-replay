#!/bin/bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# installing essentials
printf '\e[33m%s\e[m\n' "Installing essential packages:"
packages=(git build-essential vim curl zsh)
for package in "${packages[@]}"; do
    echo -ne "  Installing ${package}..."
    "${dir}"/lib/spin.sh "${dir}"/lib/package.sh -i "$package" 2>/dev/null
    printf '\r%-50s \e[32m%20s\e[m\n' "Installing ${package}..." "[OK]"
done

# replace snap packages with native pacage
printf '\e[33m%s\e[m\n' "Replacing snap packages:"
installed_snap_packages=$(snap list | awk '{if (NR!=1) print $1}')

for package in $installed_snap_packages; do
    if [[ $(apt-cache search $package | grep -wc "$package") -eq 1 ]]; then 
        echo -ne "  Replacing ${package}..."
        "${dir}"/lib/spin.sh "${dir}"/lib/package.sh -i "$package" 2>/dev/null
        "${dir}"/lib/spin.sh "${dir}"/lib/snap-package.sh -r "$package" 2>/dev/null
        printf '\r%-50s \e[32m%20s\e[m\n' "Replacing ${package}..." "[OK]"
    else
        printf '\r%-50s \e[33m%20s\e[m\n' "Replacing ${package}..." "[KEEP]"
    fi
done

# remove unwanted ubuntu tweaks
printf '\e[33m%s\e[m\n' "Removing gnome extensions:"
unwanted_packages=(gnome-shell-extension-ubuntu-dock gnome-shell-extension-desktop-icons gnome-shell-extension-appindicator)
for package in "${unwanted_packages[@]}"; do
    echo -ne "  Removing $package..."
    "${dir}"/lib/spin.sh "${dir}"/lib/package.sh -r "$package" 2>/dev/null
    printf '\r%-50s \e[32m%20s\e[m\n' "Removing ${package}..." "[OK]"
done

# nodejs stable
VERSION=node_10.x # get this live
DISTRO="$(lsb_release -s -c)"
printf '\e[33m%s\e[m\n' "Installing nodejs (${VERSION}):"
echo -ne "  Preparing nodejs repository..."
if [[ ! -f /etc/apt/sources.list.d/nodesource.list ]]; then 
    # workaround as I could not figure out how to pass this as an argument to the spinner
    { curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - &>/dev/null; 
    echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list >/dev/null; 
    echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list >/dev/null; 
    sudo apt-get update >/dev/null; }&
    pid=$! # Process Id of the previous running command
    spin='-\|/'
    i=0
    tput civis # hide cursor
    while kill -0 $pid 2>/dev/null
    do
        i=$(( (i+1) %4 ))
        printf '\r%s' "${spin:$i:1}"
        sleep .1
    done
    tput cnorm # show cursor
fi
printf '\r%-50s \e[32m%20s\e[m\n' "Preparing nodejs repository..." "[OK]"
echo -ne "  Installing nodejs and npm tools"
"${dir}"/lib/spin.sh "${dir}"/lib/package.sh -i "nodejs" 2>/dev/null
(sudo npm config set unsafe-perm true)
printf '\r%-50s \e[32m%20s\e[m\n' "Installing nodejs..." "[OK]"

# oh-my-zsh
printf '\e[33m%s\e[m\n' "Setting up shell environment:"
echo -ne "  Installing oh-my-zsh..."
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then 
    "${dir}"/lib/spin.sh sh -c "RUNZSH=no $(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &>/dev/null
fi
printf '\r%-50s \e[32m%20s\e[m\n' "Installing oh-my-zsh..." "[OK]"
echo -ne "  Installing zsh-syntax-highligthing..."
if [[ ! -d "${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
        "${dir}"/lib/spin.sh git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" &>/dev/null
fi 
(sudo -S chsh -s '/usr/bin/zsh' "${USER}")
printf '\r%-50s \e[32m%20s\e[m\n' "Installing zsh-syntax-highlighting..." "[OK]"
# installing pure-prompt
echo -ne "  Installing pure-prompt..."
"${dir}"/lib/spin.sh "${dir}"/lib/npm-package.sh -i "pure-prompt" 2>/dev/null
(sed -i -e 's/ZSH_THEME=".*"/ZSH_THEME=""/' "${HOME}"/.zshrc)
(grep -qxF 'autoload -U promptinit; promptinit' "${HOME}"/.zshrc || echo 'autoload -U promptinit; promptinit' >> "${HOME}"/.zshrc)
(grep -qxF 'prompt pure' "${HOME}"/.zshrc || echo 'prompt pure' >> "${HOME}"/.zshrc)
printf '\r%-50s \e[32m%20s\e[m\n' "Installing pure-prompt..." "[OK]"

# installing additional packages
printf '\e[33m%s\e[m\n' "Installing additional packages:"
packages=(evolution-ews)
for package in "${packages[@]}"; do
    echo -ne "  Installing ${package}..."
    "${dir}"/lib/spin.sh "${dir}"/lib/package.sh -i "$package" 2>/dev/null
    printf '\r%-50s \e[32m%20s\e[m\n' "Installing ${package}..." "[OK]"
done