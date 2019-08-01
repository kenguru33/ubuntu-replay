# shellcheck shell=bash

PACKAGES=(
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

SNAP_PACKAGES=(
    spotify
    slack
)

REMOVE_PACKAGES=(
    gnome-shell-extension-ubuntu-dock
    gnome-shell-extension-desktop-icons
    gnome-shell-extension-appindicator
    thunderbird
)

# web url supported only - images downloaded to ~/.wallpaper/{wallpaper.jpg, lockscreen.jpg} 
IMAGE_URL_DESKTOP="https://unsplash.com/photos/PwzISwC2kLs/download?force=true"
IMAGE_URL_LOCKSCREEN="https://unsplash.com/photos/z1x7Pq1Bxbg/download?force=true"

BUTTON_LAYOUT=":close" # :close:maximize:minimize
TAP_TO_CLICK="true" # true | false
FONT_HINTING="full"
FONT_ANTIALIASING="rgba"

declare -A REPO_KEY=(
    [nodjs]=""
    [google-chrome]=""
    [code]=""
)

declare -A REPO_URL=(
    [nodjs]=""
    [google-chrome]=""
    [code]=""
)