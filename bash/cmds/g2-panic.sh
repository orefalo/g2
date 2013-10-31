#!/bin/bash
#

"$GIT_EXE" rev-parse || exit 1

read -p "This action will discard all work in progress and checkout HEAD, are you sure (y/n)? " -n 1 -r
echo
[[ $REPLY == [yY]* ]] && {
    echo
    "$GIT_EXE" abort
    g2excludes=$("$GIT_EXE" config --global --get g2.panic.excludes)
    "$GIT_EXE" reset --hard HEAD && "$GIT_EXE" clean -fdx $g2excludes

    branch=$("$GIT_EXE" branch | sed -n '/\* /s///p')
    [[ $branch = "(no branch)" ]] && "$GIT_EXE" checkout master
}
