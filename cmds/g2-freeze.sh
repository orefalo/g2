#!/bin/bash
#

source "$G2_HOME/cmds/color.sh"

if [[ $1 = "-m" ]]; then
    [[ -n $2 ]] && { msg=$2; shift 2; } || { echo_info "Usage: freeze -m message"; exit 1; }
fi

( [[ -z "$@" ]] && "$GIT_EXE" add -A || "$GIT_EXE" add -A "$GIT_PREFIX$@" ) && {
    [[ -n $msg ]] && {
        "$GIT_EXE" g2iswip || exit 1
        "$GIT_EXE" commit -m "$msg" && "$GIT_EXE" status -s
    }
}
exit 0
