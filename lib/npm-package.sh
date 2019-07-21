#!/bin/bash

usage () {
cat <<TXT
    description:
	Manage native packages.

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
isInstalled () {
	[[ $(npm -g list --depth 0 | grep -wc "$1" 2>/dev/null) -eq 1 ]]
}

installed_package_version () {
	version=$(npm -g list --depth 0 | grep -w "$1" | awk -F @ '{print$2}' 2>/dev/null)
	if [[ ! "$version" ]]; then
		printf '%s\n' "$1 is not installed" >&2
		exit 1
	fi
	printf '%s\n' "$version"
}

install_package () {
	if ! isInstalled "$1"; then 
		sudo npm install -g "$1" >/dev/null
	else
		printf '%s\n' "$1 is allready installed. No further action taken." >&2
		exit 1
	fi
}

remove_package () {
	if  isInstalled "$1"; then
		sudo npm remove -g "$1" >/dev/null
	else
		printf '%s\n' "$1 is not installed" >&2
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

