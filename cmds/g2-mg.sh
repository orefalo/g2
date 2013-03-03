#!/bin/bash
#

source "$G2_HOME/cmds/color.sh"

[[ $("$GIT_EXE" g2iswip) = "true" ]] && echo_fatal "fatal: merging on a wip commit is forbiden, please <unwip> and commit <ci> first..." && exit 1

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

[[ $("$GIT_EXE" g2isbehind) = "true" ]] && read -p "It appears the current branch is in the past, proceed with the merge (y/n)? " -n 1 -r && [[ $REPLY != [yY]* ]] && exit 0

# merge returns 0 when it merges correctly
"$GIT_EXE" merge "$@" || {

    unmerged=$("$GIT_EXE" ls-files --unmerged)
    if [[ -n $unmerged ]]; then
        echo_info "info: some files need to be merged manually, please use <mt> to fix conflicts..."
        echo_info " once all resolved, <freeze> and <commit> the files."
        echo_info " note that you may <abort> at any time."
    fi
    exit 1;
}
