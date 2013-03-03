#!/bin/bash
#
# push, but with a bunch of validations
#  forbids wip commits from being pushed
#  forbids push to the working branch

source "$G2_HOME/cmds/color.sh"

error() {
    echo_fatal "fatal: sorry you can't use <push> in this context, please use the <sync> command to synchronize the current branch"
    exit 1
}

usage() {
    echo_fatal "Usage: push <?opts> <remote> <branch>"
    exit 1
}

hasFFlag() { 
	local opt
	while getopts ":f" opt; do
	  case $opt in
	    f)
	      echo "true" && return
	      ;;
	  esac
	done
	echo "false"
}

fflg=$( hasFFlag "$@" )
n=$#;
[[ $fflg = "false" && $n -eq 0 ]] && error
[[ $("$GIT_EXE" g2iswip) = "true" ]] && echo_fatal "fatal: pushing a wip commit is forbiden, please <unwip> and commit <ci>" && exit 1
[[ $fflg = "true" ]] && {
    read -p "warning: you are about to force push history, please confirm (y/n)? " -n 1 -r;
    echo
    [[ $REPLY == [yY]* ]] && "$GIT_EXE" push "$@";
    exit $?;
}

branch=${!n}
[[ $branch = */* ]] && usage

let n--
[[ $n -gt 0 && ${!n} != -* ]] && rmt=${!n} || usage
to="$rmt/$branch"
remote=$("$GIT_EXE" g2getremote)
if [[ -z $remote ]]; then
    read -p "Would you like to track $to (y/n)? " -n 1 -r
    echo
else
    [[ $to = $remote ]] && error
fi
"$GIT_EXE" push "$@" && [[ $REPLY == [yY]* ]] && "$GIT_EXE" track $to