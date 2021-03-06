# shellcheck shell=bash

debPackageInstall() {
    local package="$1"
    sudo apt-get install -y "$package"
}

debPackageUpdate() {
    sudo apt-get update
}

debPackageUpgrade() {
    sudo apt-get upgrade -y
}

debPackageCleanup() {
    sudo apt-get autoremove
    sudo apt-get clean
}

debPackageRemove() {
    local package="$1"
    sudo apt-get --purge remove -y "$package"
    sudo apt-get autoclean
    sudo apt clean
}

debPackageAddRepoKey() {
    local url="$1"
    wget -q -O - "$url" | sudo apt-key add -
}

debPackageRepoIsRegistered() {
    repo="$1"
    if [[ "$(ls -A /etc/apt/sources.list.d)" ]]; then
        [[ $(grep -h ^deb /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -Fc "${repo}") -eq 1 ]]
    else 
        [[ $(grep -h ^deb /etc/apt/sources.list | grep -Fc "${repo}") -eq 1 ]]
    fi
}
debPackageAddRepo() {
    repo="$1"
    name="$2"

    if ! debPackageRepoIsRegistered "$repo"; then 
        echo "${repo}" | sudo tee -a "/etc/apt/sources.list.d/${name}.list"
    fi
}

debPackageIsInstalled() {
    local package=$1
    (dpkg-query -W --showformat='${Status}\n' "$package" | grep "install ok installed")
}

snapPackageInstall() {
    local package="$1"
    if [[ "$(snap search "$package" | awk '{print $1 " : "  $4}' | grep -w classic | grep -c "$package ")" -eq 1 ]]; then
        sudo snap install --classic "$package"
        sudo snap install "$package"
    fi
}

snapPackageRemove() {
    local package="$1"
    sudo snap remove "$package"
}








