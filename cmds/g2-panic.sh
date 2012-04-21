#!/bin/bash
#

read -p "Remove all untracked files and checkout HEAD, are you sure (y/n)? " -n 1 -r
[[ $REPLY == [yY]* ]] && {
    echo
    "$GIT_EXE" abort
    "$GIT_EXE" reset --hard HEAD && "$GIT_EXE" clean -fdx

    branch=$("$GIT_EXE" branch | grep "*" | sed "s/* //")
    [[ $branch = "(no branch)" ]] && "$GIT_EXE" checkout master
}
