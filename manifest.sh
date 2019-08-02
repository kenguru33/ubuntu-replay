# shellcheck shell=bash

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
    [nodejs]="deb https://deb.nodesource.com/node_10.x disco main" 
    [google-chrome]="deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
    [vscode]="deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
)
export -A REPO_DEB_SRC=(
    [nodejs]="deb-src https://deb.nodesource.com/node_10.x disco main"
)
