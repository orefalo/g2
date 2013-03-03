#!/bin/bash
#
# easy undo a file, a commit or a merge

source "$G2_HOME/cmds/color.sh"

if [ $# -lt 1 ]
then
    echo_info "Usage : g undo <file|commit|merge> <?path>"
    exit
fi

read -p "warning: the action may discard your changes, please confirm (y/n)? " -n 1 -r
echo
[[ $REPLY = [nN]* ]] && exit 0

case "$1" in

    "commit")
        #TODO: Validate local commits
        echo_info "Undoing last commit and reverting changes to the staging area."
        "$GIT_EXE" reset --soft HEAD^
    ;;
    "merge")
        #TODO: Validate local commits
        echo_info "Reverting back prior to the last merge."
        "$GIT_EXE" reset --hard ORIG_HEAD
    ;;
    *)
	"$GIT_EXE" checkout -- "$GIT_PREFIX$1"
    ;;
esac
