#!/bin/bash
#

source "$G2_HOME/cmds/color.sh"


error() {
    echo_fatal $1
    exit 1
}

[[ $("$GIT_EXE" diff --cached --numstat | wc -l) -eq 0 ]] && error "fatal: no files to amend, please <freeze> the changes to amend."

remote=$("$GIT_EXE" g2getremote)
if [[ -z $remote ]]; then
    "$GIT_EXE" commit --amend -C HEAD
else

    if [[ $("$GIT_EXE" log $remote..HEAD --oneline | wc -l) -eq 0 ]]; then

        if [[ $1 = "-f" ]]; then
            read -p "warning: force amending will rewrite the branch history, please confirm (y/n)? " -n 1 -r
            echo
            [[ $REPLY != [yY]* ]] && exit 1
        else error "fatal: no local commits to amend."; fi
    fi

    "$GIT_EXE" commit --amend -C HEAD

fi