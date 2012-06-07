#!/bin/bash
#

if [ $# -lt 1 ]
then
    echo "Usage : g undo <file|'commit'|'merge'>"
    exit
fi

read -p "warning: the action will discard your changes, please confirm (y/n)? " -n 1 -r
echo
[[ $REPLY = [nN]* ]] && exit 0

case "$1" in

    "commit")
        #TODO: Validate local commits
        echo "Undoing last commit and reverting changes to the staging area."
        "$GIT_EXE" reset --soft HEAD^
    ;;
    "merge")
        #TODO: Validate local commits
        echo "Reverting back prior to the last merge."
        "$GIT_EXE" reset --hard ORIG_HEAD
    ;;
    *) "$GIT_EXE" checkout -- "$1"
    ;;
esac
