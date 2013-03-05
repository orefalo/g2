#!/bin/bash
#

source "$G2_HOME/cmds/color.sh"

$("$GIT_EXE" g2iswip) || exit 1

# substitute "upstream" with real upstream name
declare -a v=("$@")
declare i=0
for a in "${v[@]}"
do
    [[ "$a" = "upstream" ]] && {
        remote=$("$GIT_EXE" g2getremote)
        [[ -z $remote ]] && error "Upstream not found, please setup tracking for this branch, ie. ${boldon}g track remote/branch${boldoff}"
        set -- "${@:1:$i}" "origin/master" "${@:($i+2)}";
    } && break
    let i++
done

$("$GIT_EXE" g2isbehind) && read -p "It appears the current branch is in the past, proceed with the merge (y/n)? " -n 1 -r && [[ $REPLY != [yY]* ]] && exit 0

# merge returns 0 when it merges correctly
"$GIT_EXE" merge "$@" || {

    unmerged=$("$GIT_EXE" ls-files --unmerged)
    if [[ -n $unmerged ]]; then
        echo_info "A few files need to be merged manually, please use <g mt> to fix conflicts..."
        echo_info " once all resolved, <g freeze> and <g commit> the files."
        echo_info " note: you may abort the merge at any time with <g abort> ."
    fi
    exit 1;
}
