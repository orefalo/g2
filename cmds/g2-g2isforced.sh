#!/bin/bash
#
# returns 0 if the given branch was force updated, 1 if not
#   if no parameters, figures the upstream branch from the tracking table

"$GIT_EXE" rev-parse || exit 1

remote=$1
[[ -z $1 ]] && remote=$("$GIT_EXE" g2getremote)
[[ -n $remote ]] && {
    hash=$("$GIT_EXE" reflog $remote | head -1 | grep forced-update | cut -f 1 -d " ")
    branch=$("$GIT_EXE" branch | grep "*" | sed "s/* //")
    [[ -n $hash && $("$GIT_EXE" reflog $branch | grep $hash | grep -c reset) -eq 0 ]] && exit 0
}
exit 1
