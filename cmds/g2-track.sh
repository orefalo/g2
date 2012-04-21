#!/bin/bash
#

if [[ $# -eq 1 ]]; then
    [[ $1 != */* ]] && echo "fatal: $1 is not an upstream branch (ie. origin/xxx)." && exit 1
    branch=$("$GIT_EXE" branch | grep "*" | sed "s/* //")
    "$GIT_EXE" branch --set-upstream $branch $1
else
    "$GIT_EXE" for-each-ref --format="local: %(refname:short) <--sync--> remote: %(upstream:short)" refs/heads
    echo "--Remotes------"
    "$GIT_EXE" remote -v
fi