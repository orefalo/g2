#!/bin/bash
#
#
source "$G2_HOME/cmds/color.sh"

$("$GIT_EXE" g2iswip) || exit 1
[[ $("$GIT_EXE" diff --cached --numstat | wc -l) -eq 0 ]] && echo_fatal "fatal: No files to commit, please <freeze> changes first." || "$GIT_EXE" commit -u "$@"
