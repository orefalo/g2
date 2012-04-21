#!/bin/bash
#

error() {
    echo "fatal: use <sync> to synchronize the current branch"
    echo "remember, <sync>hing applies to the working branch, <pull>ing applies when merging feature branches."
    exit 1
}

n=$#;
[[ $n -eq 0 || ${!n} = -* ]] && error
#[[ $("$GIT_EXE" g2iswip) = "true" ]] && echo "fatal: pulling on a wip commit is forbidden, please <unwip> and commit <ci>" && exit 1
[[ ${!n} = */* ]] && echo "Usage: pull <?opts> <remote> <branch>" && exit 1
branch=${!n}
let n--
[[ n -gt 0 && ${!n} != -* ]] && rmt=${!n} || { echo "Usage: pull <remote> <branch>" && exit 1; }
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
