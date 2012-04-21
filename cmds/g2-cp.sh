#!/bin/bash
#

[[ $("$GIT_EXE" g2iswip) = "true" ]] && echo "fatal: Cherry Picking on a WIP commit is forbiden, please <unwip> and commit <ci>" && exit 1
"$GIT_EXE" cherry-pick "$@"