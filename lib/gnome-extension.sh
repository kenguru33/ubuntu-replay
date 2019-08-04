#!/bin/bash
extensionInstall() {
    # extension id
    EXTENSION_ID="$1"
    # create random tempfile for description
    TMP_DESC="$(mktemp)"
    # create random tempfile for zipfile
    TMP_ZIP="$(mktemp)"
    # extenion path
    EXTENSION_PATH="${HOME}/.local/share/gnome-shell/extensions"
    # set gnome shell extension site URL
    GNOME_SITE="https://extensions.gnome.org"
    # get gnome version
    GNOME_VERSION=$(gnome-shell --version | tr -cd "0-9." | cut -d'.' -f1,2)
    # get extension description
    wget -q -O "${TMP_DESC}" "${GNOME_SITE}/extension-info/?pk=${EXTENSION_ID}&shell_version=${GNOME_VERSION}"
    # get extension UUID
    EXTENSION_UUID=$(sed 's/^.*uuid[\": ]*\([^\"]*\).*$/\1/' "${TMP_DESC}")
    # get extension download URL
    EXTENSION_URL=$(sed 's/^.*download_url[\": ]*\([^\"]*\).*$/\1/' "${TMP_DESC}")
    # download extension archive
    wget -q -O "${TMP_ZIP}" "${GNOME_SITE}${EXTENSION_URL}"
    mkdir -p "${EXTENSION_PATH}/${EXTENSION_UUID}"
    unzip -oq "${TMP_ZIP}" -d "${EXTENSION_PATH}/${EXTENSION_UUID}"
    gnome-shell-extension-tool -e "${EXTENSION_UUID}"
}
