#!/bin/bash
#

remote=$("$GIT_EXE" rev-parse --symbolic-full-name --abbrev-ref @{u} 2> /dev/null)
[[ $remote == "@{u}" ]] && echo "" || echo $remote
