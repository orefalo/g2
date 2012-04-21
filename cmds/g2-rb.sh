#!/bin/bash
#

#TODO: make sure we are clear

read -p "The history is about to be rewritten. This might be a dangerous operation, please confirm (y/n)? " -n 1 -r
echo
[[ $REPLY = [yY]* ]] && "$GIT_EXE" rebase "$@"