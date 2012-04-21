#!/bin/bash
#

error() {
    echo "fatal: no files to amend, please <freeze> the changes to amend."
    exit 1
}

[[ $("$GIT_EXE" diff --cached --numstat | wc -l) -eq 0 ]] && error

remote=$("$GIT_EXE" g2getremote)
if [[ -z $remote ]]; then
    "$GIT_EXE" commit --amend -C HEAD
else

    if [[ $("$GIT_EXE" log $remote..HEAD --oneline | wc -l) -eq 0 ]]; then

        if [[ $1 = "-f" ]]; then
            read -p "warning: force amending will rewrite the branch history, please confirm (y/n)? " -n 1 -r
            echo
            [[ $REPLY != [yY]* ]] && exit 1
        else error; fi
    fi

    "$GIT_EXE" commit --amend -C HEAD

fi