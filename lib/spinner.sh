#!/bin/bash

# Colors
green="\\e[1;32m"
red="\\e[1;31m"
nc="\\e[0m"

spinner(){
	case $1 in
	start)
		declare -i rightMargin="${3:-64}"
		_label="${2:-Doing some work...}"
		_column=$(( $(tput cols)-${#_label}-rightMargin ))
		_start_spinner &
		_pid=$!
	;;
	stop)
		if [[ ! -z $_pid ]]; then 
			_stop_spinner "$2"
			unset _pid
		else 
			printf "%s" "Error: Spinner is not running." >&2
			exit 1
		fi
	;;
	*)
		printf "%s\n" "Invalid arguments"
		printf "%s\n" "Usage: spinner start <label> <rightMargin> | stop $?"
	;;
	esac
}

_start_spinner() {
	local spinner="|/-\\"
	printf "%s%${_column}s" "${_label}"
	while 'true'; do
		for i in {0..3}; do
			printf "[ %s  ]" "${spinner:$i:1}"
			sleep .1
			printf "\\b\\b\\b\\b\\b\\b"
		done
	done
}

_stop_spinner() {
	local status="$1"
	printf "\\r%s%${_column}s" "${_label}"
	if [[ "$status" -eq 0 ]]; then
		printf "[$green%s$nc]\\n" "DONE"
	else 
		printf "[ $red%s$nc ]\\n" "FAIL"
	fi
	kill "$_pid" &>/dev/null

}


