#!/bin/bash
#
source "$G2_HOME/cmds/color.sh"

[[ $("$GIT_EXE" diff --cached --numstat | wc -l) -eq 0 ]] && error "fatal: no files to amend, please <freeze> the changes to amend."

$("$GIT_EXE" g2haslocalcommit)
if [[ $? -eq 0 ]]; then
    if [[ $1 = "-f" ]]; then
        read -p "Warning: force amending will rewrite the history, please confirm (y/n)? " -n 1 -r
        echo
        [[ $REPLY != [yY]* ]] && exit 1
    else
        echo_fatal "fatal: no local commits to amend."
        exit 1
    fi
fi

"$GIT_EXE" commit --amend -C HEAD