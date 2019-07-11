#!/bin/bash

if (!(npm -g list --depth 0 | grep -w $1) > /dev/null )
    then 
        sudo npm install -g $1 &>/dev/null  &
        pid=$! # Process Id of the previous running command
        spin='-\|/'

        i=0
        while kill -0 $pid 2>/dev/null
        do
            i=$(( (i+1) %4 ))
            printf "\r${spin:$i:1} installing $1"
            sleep .1
        done
        echo ""
fi