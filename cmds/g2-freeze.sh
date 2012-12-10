#!/bin/bash
#

[[ $1 = "-m" ]] && {
    [[ -n $2 ]] && { msg=$2; shift 2; } || { echo "Usage: freeze -m message"; exit 1; }
}
( [[ -z "$@" ]] && "$GIT_EXE" add -A || "$GIT_EXE" add -A "$GIT_PREFIX$@" ) && {
    [[ -n $msg ]] && {
        [[ $("$GIT_EXE" g2iswip) = "true" ]] && echo "fatal: wip detected, please <unwip> and commit <ci>." && exit 1
        "$GIT_EXE" commit -m "$msg" && "$GIT_EXE" status -s
    }
}
exit 0
