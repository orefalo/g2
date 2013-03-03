#!/bin/bash
#

source "$G2_HOME/cmds/color.sh"

# substitute "upstream" with real upstream name
declare -a v=("$@")
declare i=0
for a in "${v[@]}"
do
    [[ "$a" = "upstream" ]] && {
        remote=$("$GIT_EXE" g2getremote)
        [[ -z $remote ]] && echo_fatal "fatal: upstream not found, please setup tracking for this branch, ie. <g track remote/branch>" && exit 1
        set -- "${@:1:$i}" "origin/master" "${@:($i+2)}";
        } && break
    let i++
done

[[ $("$GIT_EXE" g2brstatus) = "false" ]] && {
    read -p "The history is about to be rewritten. This is a dangerous operation, please confirm (y/n)? " -n 1 -r
    echo
    [[ $REPLY = [nN]* ]] && exit 0
}

"$GIT_EXE" rebase "$@"