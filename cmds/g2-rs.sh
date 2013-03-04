#!/bin/bash
#

[[ $1 == "upstream" ]] && {
    read -p "warning: resetting to the upstream may erase any local changes, are you sure (y/n)? " -n 1 -r
    echo
    [[ $REPLY == [yY]* ]] && { echo
        "$GIT_EXE" abort
        remote=$("$GIT_EXE" g2getremote)
        [[ -n $remote ]] && { echo "Resetting branch to $remote" && "$GIT_EXE" reset --hard "$remote"; } || echo "fatal: please setup tracking for this branch, see <track>";
    }
} || "$GIT_EXE" reset "$@";
