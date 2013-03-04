#!/bin/bash
#

source "$G2_HOME/cmds/color.sh"

error() {
    echo_fatal "fatal: use <sync> to synchronize the current branch"
    echo_info "remember, <sync>hing applies to the working branch, <pull>ing applies when merging feature branches."
    exit 1
}

usage() {
    echo_fatal "Usage: pull <?opts> <remote> <branch>"
    exit 1
}

n=$#;
[[ $n -eq 0 || ${!n} = -* ]] && error
$("$GIT_EXE" g2iswip) || exit 1
[[ ${!n} = */* ]] && usage
branch=${!n}
let n--
[[ n -gt 0 && ${!n} != -* ]] && rmt=${!n} || usage
to="$rmt/$branch"
remote=$("$GIT_EXE" g2getremote)
if [[ -z $remote ]]; then
    read -p "Would you like to track $to (y/n)? " -n 1 -r
    echo
else
    [[ $to = $remote ]] && error
fi
[[ $REPLY = [yY]* ]] && "$GIT_EXE" track "$to"
"$GIT_EXE" fetch "$rmt"
"$GIT_EXE" mg --no-ff "$to"
