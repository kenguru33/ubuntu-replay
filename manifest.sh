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

export REPO_KEY=(
    #[nodjs]=""
    #[google-chrome]=""
    #[code]=""
)

export REPO_URL=(
    #[nodjs]=""
    #[google-chrome]=""
    #[code]=""
)
