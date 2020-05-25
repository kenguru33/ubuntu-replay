# shellcheck shell=bash

export DISTRO="$(lsb_release -s -c)"
export NODE_VERSION="node_12.x"

export PACKAGES=(
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
    chrome-gnome-shell
	libsecret-1-0 
	libsecret-1-dev
)

export SNAP_PACKAGES=(
    spotify
    slack
    webstorm
)

export REMOVE_PACKAGES=(
    gnome-shell-extension-ubuntu-dock
    gnome-shell-extension-desktop-icons
    gnome-shell-extension-appindicator
    thunderbird
)

# web url supported only - images downloaded to ~/.wallpaper/{wallpaper.jpg, lockscreen.jpg} 
export IMAGE_URL_DESKTOP="https://unsplash.com/photos/PwzISwC2kLs/download?force=true"
export IMAGE_URL_LOCKSCREEN="https://unsplash.com/photos/z1x7Pq1Bxbg/download?force=true"

export BUTTON_LAYOUT=":close" # :close:maximize:minimize
export TAP_TO_CLICK="true" # true | false
export FONT_HINTING="full"
export FONT_ANTIALIASING="rgba"

export -A REPO_KEY=(
    [nodejs]="https://deb.nodesource.com/gpgkey/nodesource.gpg.key"
    [google-chrome]="https://dl.google.com/linux/linux_signing_key.pub"
    [vscode]="https://packages.microsoft.com/keys/microsoft.asc"
)

export -A REPO_DEB=(
    [nodejs]="deb https://deb.nodesource.com/node_12.x $(lsb_release -s -c) main" 
    [google-chrome]="deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
    [vscode]="deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
)
export -A REPO_DEB_SRC=(
    [nodejs]="deb-src https://deb.nodesource.com/node_12.x $(lsb_release -s -c) main"
)

export DEFAULT_EDITOR="/usr/bin/vim.basic"

export GNOME_EXTENSIONS=(
    "sound-output-device-chooser@kgshank.net" 
    "caffeine@patapon.info" 
    "clipboard-indicator@tudmotu.com"
    "gnome-shell-screenshot@ttll.de"
)
