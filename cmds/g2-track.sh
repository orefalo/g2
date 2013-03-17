#!/bin/bash
#
source "$G2_HOME/cmds/color.sh"

if [[ $# -eq 1 ]]; then
    [[ $1 != */* ]] && error "${boldon}$1${boldoff} is not an upstream branch (ie. origin/xxx)."
    "$GIT_EXE" branch --set-upstream-to $1
else
    echo -e -n "${greenf}"
    "$GIT_EXE" for-each-ref --format="local: %(refname:short) <--sync--> remote: %(upstream:short)" refs/heads
    echo -e -n "${reset}"
    echo -e "${boldon}--Remotes------------${boldoff}"
    echo -e -n "${yellowf}"
    "$GIT_EXE" remote -v
    echo -e -n "${reset}"
fi
