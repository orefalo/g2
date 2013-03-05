#!/bin/bash
#
# Aborts a merge or rebase

source "$G2_HOME/cmds/color.sh"

[[ ! $("$GIT_EXE" rev-parse --git-dir 2> /dev/null) ]] && fatal "Not a Git Repository" || ("$GIT_EXE" merge --abort 2> /dev/null || "$GIT_EXE" rebase --abort 2> /dev/null)
