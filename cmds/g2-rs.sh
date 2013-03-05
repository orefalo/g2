#!/bin/bash
#

source "$G2_HOME/cmds/color.sh"

[[ $1 == "upstream" ]] && {
    read -p "warning: resetting to the upstream may erase any local changes, are you sure (y/n)? " -n 1 -r
    echo
    [[ $REPLY == [yY]* ]] && { echo
        "$GIT_EXE" abort
        remote=$("$GIT_EXE" g2getremote)
        [[ -n $remote ]] && { echo "Resetting branch to $remote" && "$GIT_EXE" reset --hard "$remote"; } || fatal "Please setup tracking for this branch, see ${boldon}g track remote/branch${boldoff}";
    }
} || "$GIT_EXE" reset "$@";
