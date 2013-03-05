#!/bin/bash
#

source "$G2_HOME/cmds/color.sh"

err() {
    fatal "Use ${boldon}sync${boldoff} to synchronize the current branch"
    error "remember, ${boldon}sync${boldoff}hing applies to the working branch, ${boldon}pull${boldoff}ing applies when merging feature branches."
}

usage() {
    echo_info "Usage: pull <?opts> <remote> <branch>"
    exit 1
}

n=$#;
[[ $n -eq 0 || ${!n} = -* ]] && err
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
    [[ $to = $remote ]] && err
fi
[[ $REPLY = [yY]* ]] && "$GIT_EXE" track "$to"
"$GIT_EXE" fetch "$rmt"
"$GIT_EXE" mg --no-ff "$to"
