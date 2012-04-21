#!/bin/bash
#

remote=$1
[[ -z $1 ]] && remote=$("$GIT_EXE" g2getremote)
[[ -n $remote ]] && {
    hash=$("$GIT_EXE" reflog $remote | head -1 | grep forced-update | cut -f 1 -d " ")
    branch=$("$GIT_EXE" branch | grep "*" | sed "s/* //")
    [[ -n $hash && $("$GIT_EXE" reflog $branch | grep $hash | grep -c reset) -eq 0 ]] && echo "true" && exit 0
}
echo "false"
