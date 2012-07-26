#!/bin/bash
#
#

[[ $("$GIT_EXE" g2iswip) = "true" ]] && echo "fatal: WIP detected, please <unwip> first." && exit 1
[[ $("$GIT_EXE" diff --cached --numstat | wc -l) -eq 0 ]] && echo "fatal: No files to commit, please <freeze> changes first." || "$GIT_EXE" commit -u "$@"
