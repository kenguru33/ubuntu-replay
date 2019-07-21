#!/bin/bash
spinner () {
    ("$@")&
    pid=$! # Process Id of the previous running command
    spin='-\|/'
    i=0
    tput civis # hide 
    while kill -0 $pid 2>/dev/null
    do
        i=$(( (i+1) %4 ))
        printf '\r%s' "${spin:$i:1}"
        sleep .1
    done
    tput cnorm
}


spinner "$@"