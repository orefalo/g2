#!/bin/bash
#

hasChanges() {
    [[ $("$GIT_EXE" diff --cached --numstat | wc -l) -ne 0 ]] && echo "fatal: staged changed detected, please commit <ci> or <wip> them." && exit 1
    [[ $("$GIT_EXE" diff --numstat | wc -l) -ne 0 ]] && echo "fatal: some files were changed in this branch, either commit <ci>, <wip> or <panic>." && exit 1
}

isBranch=$("$GIT_EXE" branch -a | grep -c "$1")
[[ $isBranch -gt 0 ]] && {
    hasChanges
    "$GIT_EXE" checkout "$@" && "$GIT_EXE" clean -fd;
    exit $?;
}

"$GIT_EXE" checkout "$@"

