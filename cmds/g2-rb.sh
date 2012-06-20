#!/bin/bash
#

[[ $("$GIT_EXE" g2brstatus) = "false" ]] && {
    read -p "The history is about to be rewritten. This is a dangerous operation, please confirm (y/n)? " -n 1 -r
    echo
    [[ $REPLY = [nN]* ]] && exit 0
}

"$GIT_EXE" rebase "$@"