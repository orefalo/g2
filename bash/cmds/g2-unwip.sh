#!/bin/bash
#

"$GIT_EXE" rev-parse || exit 1

source "$G2_HOME/cmds/color.sh"

"$GIT_EXE" g2iswip > /dev/null
if [[ $? -eq 0 ]]; then
    fatal "There is nothing to ${boldon}unwip${boldoff}..."
else
    "$GIT_EXE" log -n 1 | grep -q -c "wip" && "$GIT_EXE" reset HEAD~1
fi
