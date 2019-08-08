# shellcheck shell=bash

addPath() {
    local path="$1"
    echo $path
    if [[ $(grep -c "PATH=${path}:\$PATH" "${HOME}/.profile") -eq 0 ]]; then
        cat << EOF >> "${HOME}/.profile"

# set PATH so it includes user's private bin if it exists
if [ -d "${path}" ] ; then
    PATH="${path}:\$PATH"
fi
EOF
    fi
}

