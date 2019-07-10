#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure we are in top of home folder
cd ~

# essentials tools
#sudo apt install -y gnome-tweaks git curl vim zsh git

# remove unwanted software
#sudo apt remove -y gnome-shell-extension-ubuntu-dock
#sudo apt remove -y gnome-shell-extension-desktop-icons
#sudo apt remove -y gnome-shell-extension-appindicator

# replace default snap installed gnome application deb packages
#sudo snap remove gnome-calculator gnome-characters gnome-logs gnome-system-monitor
#sudo apt install -y gnome-calculator gnome-characters gnome-logs gnome-system-monitor

# install nodejs
#curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
#sudo apt install -y nodejs

# setup npm
#sudo npm config set unsafe-perm true

#install prompt theme
#sudo npm i -g pure-prompt

# oh-my-zsh
if [ ! -d ".oh-my-zsh" ]; then
	
	sh -c "RUNZSH=no $(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	cp zshrc ~/.zshrc
fi

