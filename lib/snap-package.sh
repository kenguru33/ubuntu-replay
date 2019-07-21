#!/bin/bash

usage () {
cat <<TXT
    description:
	Manage snap packages.

    usage: 
	package options pkg_name

	valid options: 
	-i install package
	-v get version of installed package
	-r remove package

	Examples:

	install package:
	package -i git

	version of installed package:
	package -v git

	remove package:
	package -r git
TXT
}

installed_package_version () {
    version="$(snap info "$1" | grep -w installed: | awk '{print $2}')"
    if [[ ! "$version" ]]; then 
        printf '%s\n' "$1 is not installed" >&2
		exit 1
    fi
    printf '%s\n' "$version" 
}  

isInstalled () {
    [[ "$(snap info "$1" | grep -w installed: | awk '{print $2}')" ]]
}

isClassic () {
    [[ "$(snap search "$1" | awk '{print $1 " : "  $4}' | grep -w classic | grep -c "$1 ")" -eq 1 ]]
}

install_package () {
    if isInstalled "$1";then 
       printf '%s\n' "$1 is already install. No further action taken." >&2
       exit 1
    fi
    if isClassic "$1"; then 
        sudo snap install --classic "$1" >/dev/null
        else
        sudo snap install "$1" >/dev/null
    fi
}

remove_package () {
    if (isInstalled "$1"); then 
        sudo snap remove "$1" >/dev/null
    else
        printf '%s\n' "$1 is not installed. No further action taken." >&2
        exit 1  
    fi
}

while getopts ":i:v:r:si" options; do
	case "${options}" in
	i)
		install_package "${OPTARG}" 
	;;
	v)
		(installed_package_version "${OPTARG}")
	;;
	r)
		(remove_package "${OPTARG}")
	;;
	*)
		printf '%s\n' "Unknown option -${OPTARG}"
		usage
	;;
	esac
done
