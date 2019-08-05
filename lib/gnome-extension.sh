#!/bin/bash

readonly GNOME_VERSION=$(gnome-shell --version | tr -cd "0-9." | cut -d'.' -f1,2)
readonly EXTENSION_PATH="${HOME}/.local/share/gnome-shell/extensions"
readonly GNOME_SITE="https://extensions.gnome.org"

extensionEnable() {
    local uuid="$1"
    if [[ $(gsettings get org.gnome.shell enabled-extensions | grep -wc "$uuid") -eq 0 ]]; then 
        gnome-shell-extension-tool -e "$uuid" 
    fi 
}

extensionDisable() {
    local uuid="$1"
    if [[ $(gsettings get org.gnome.shell enabled-extensions | grep -wc "$uuid") -eq 1 ]]; then 
        gnome-shell-extension-tool -d "$uuid"
    fi
}

fetchDescriptionFileByPk() {
    local extensionId="$1"
    local descriptionFile
    descriptionFile=$(mktemp)
    wget -q -O "$descriptionFile" "${GNOME_SITE}/extension-info/?pk=${extensionId}&shell_version=${GNOME_VERSION}"
    echo "$descriptionFile"
}

extensionInstall() {
    local uuid="$1"
    local zipFile="$2"
    mkdir -p "${EXTENSION_PATH}/${uuid}"
    unzip -oq "$zipFile" -d "${EXTENSION_PATH}/${uuid}"
}

fetchZipFile() {
    local url="$1"
    local zipFile
    zipFile=$(mktemp)
    wget -q -O "$zipFile" "$url"
    echo "$zipFile"
}

extensionUUID() {
    local descriptionFile="$1"
    local uuid
    uuid=$(sed 's/^.*uuid[\": ]*\([^\"]*\).*$/\1/' "$descriptionFile")
    echo "$uuid"
}

extensionUrl() {
    local descriptionFile="$1"
    local url
    url=$(sed 's/^.*download_url[\": ]*\([^\"]*\).*$/\1/' "$descriptionFile")
    echo "${GNOME_SITE}/${url}"
}

fetchDescriptionFileByUUID() {
    local uuid="$1"
    local descriptionFile
    descriptionFile=$(mktemp)
    wget -q -O "$descriptionFile" "${GNOME_SITE}/extension-info/?uuid=${uuid}&shell_version=${GNOME_VERSION}"
    echo "$descriptionFile"
}
