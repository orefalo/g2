#!/bin/bash
#
#
source "$G2_HOME/cmds/color.sh"

"$GIT_EXE" g2iswip || exit 1
[[ $("$GIT_EXE" diff --cached --numstat | wc -l) -eq 0 ]] && fatal "No files to commit, please use ${boldon}g freeze${boldoff} to stage changes." || "$GIT_EXE" commit -u "$@"
