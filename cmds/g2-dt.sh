#!/bin/bash
#

# substitute "upstream" with real upstream name
declare -a v=("$@")
declare i=0
for a in "${v[@]}"
do
    [[ "$a" = "upstream" ]] && {
        remote=$("$GIT_EXE" g2getremote)
        [[ -z $remote ]] && echo "fatal: upstream not found, please setup tracking for this branch, ie. <g track remote/branch>" && exit 1
        set -- "${@:1:$i}" "origin/master" "${@:($i+2)}";
    } && break
    let i++
done


"$GIT_EXE" difftool "$@"
