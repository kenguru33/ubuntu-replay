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
	dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -c "ok installed"
}

installed_package_version () {
	version="$(dpkg-query -W -f='${Version}' "$1" 2>/dev/null)"
	if [[ ! "$version" ]]; then
		printf '%s\n' "$1 is not installed" >&2
		exit 1
	fi
	printf '%s\n' "$version"
}

install_package () {
	if [[ "$(isInstalled "$1")" -eq 0 ]]; then 
		sudo apt-get install -y "$1" >/dev/null
	else
		printf '%s\n' "$1 is allready installed. No further action taken." >&2
		exit 1
	fi
}

remove_package () {
	if  [[ "$(isInstalled "$1")" -eq 1 ]]; then
		sudo apt-get --purge remove -y "$1" >/dev/null
	else
		printf '%s\n' "$1 is not installed" >&2
		exit 1
	fi
}

update_packages () {
	sudo apt-get update >/dev/null
	sudo apt-get upgrade -y >/dev/null
}

while getopts ":i:v:r:u" options; do
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
	u)
		(update_packages "${OPTARG}")
	;;
	*)
		printf '%s\n' "Unknown option -${OPTARG}"
		usage
	;;
	esac
done

