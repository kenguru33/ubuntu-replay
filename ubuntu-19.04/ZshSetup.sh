#!/bin/bash

function oh-my-zsh() {
    sh -c "RUNZSH=no $(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &>/dev/null &
    pid=$! # Process Id of the previous running command
    spin='-\|/'

    i=0
    while kill -0 $pid 2>/dev/null
    do
        i=$(( (i+1) %4 ))
        printf "\r${spin:$i:1} Setting up zsh environment (oh-my-zsh)"
        sleep .1
    done
    echo ""
}

function zsh-plugin-syntax-highlighting() {
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &>/dev/null &
    pid=$! # Process Id of the previous running command
    spin='-\|/'

    i=0
    while kill -0 $pid 2>/dev/null
    do
        i=$(( (i+1) %4 ))
        printf "\r${spin:$i:1} Setting up zsh plugin syntax highlighting"
        sleep .1
    done
    echo ""
}

function zsh-config() {
    curl https://raw.githubusercontent.com/kenguru33/ubuntu-replay/master/ubuntu-19.04/config/zshrc --output ~/.zshrc &>/dev/null &
    pid=$! # Process Id of the previous running command
    spin='-\|/'

    i=0
    while kill -0 $pid 2>/dev/null
    do
        i=$(( (i+1) %4 ))
        printf "\r${spin:$i:1} installing zsh config"
        sleep .1
    done
    echo ""
}

DIR=~/.oh-my-zsh
if [ ! -d "${DIR}" ]; then
  oh-my-zsh
  zsh-plugin-syntax-highlighting
  zsh-config
fi