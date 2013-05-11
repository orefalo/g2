#!/bin/bash
#
# Returns 0 if the branch is behind its upstream branch, 1 if not

"$GIT_EXE" rev-parse || exit 1

local=$("$GIT_EXE" branch | grep "*" | sed "s/* //")
remote=$1
[[ -z $1 ]] && remote=$("$GIT_EXE" g2getremote)
[[ -n $remote ]] && {
    "$GIT_EXE" fetch
    RIGHT_AHEAD=$("$GIT_EXE" rev-list --left-right ${local}...${remote} -- 2> /dev/null | grep -c "^>")
    [[ $RIGHT_AHEAD -gt 0 ]] && exit 0;
}
exit 1;
