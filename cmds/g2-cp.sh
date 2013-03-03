#!/bin/bash
#
# Cherry picking, but forbids anything on top of wip commit

source "$G2_HOME/cmds/color.sh"

[[ $("$GIT_EXE" g2iswip) = "true" ]] && echo_fatal "fatal: Cherry Picking on a WIP commit is forbiden, please <unwip> and commit <ci>" && exit 1
"$GIT_EXE" cherry-pick "$@"