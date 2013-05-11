#!/bin/bash
#
# returns the upstream branch name if any

"$GIT_EXE" rev-parse || exit 1

remote=$("$GIT_EXE" rev-parse --symbolic-full-name --abbrev-ref @{u} 2> /dev/null)
[[ $remote == "@{u}" ]] && echo "" || echo $remote
