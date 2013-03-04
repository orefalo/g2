#!/bin/bash
#
# Returns 1 if the branch is behind its upstream branch, 0 if not

local=$("$GIT_EXE" branch | grep "*" | sed "s/* //")
remote=$1
[[ -z $1 ]] && remote=$("$GIT_EXE" g2getremote)
[[ -n $remote ]] && {
    "$GIT_EXE" fetch
    RIGHT_AHEAD=$("$GIT_EXE" rev-list --left-right ${local}...${remote} -- 2> /dev/null | grep -c "^>")
    [[ $RIGHT_AHEAD -gt 0 ]] && exit 1;
}
exit 0;
