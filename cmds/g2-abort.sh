#!/bin/bash
#
# Aborts a merge or rebase

[[ ! $("$GIT_EXE" rev-parse --git-dir 2> /dev/null) ]] && echo "fatal: Not a Git Repository" || ("$GIT_EXE" merge --abort 2> /dev/null || "$GIT_EXE" rebase --abort 2> /dev/null)
