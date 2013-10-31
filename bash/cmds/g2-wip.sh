#!/bin/bash
#

"$GIT_EXE" rev-parse || exit 1

source "$G2_HOME/cmds/color.sh"

"$GIT_EXE" g2iswip > /dev/null
if [[ $? -eq 1 ]]; then
    echo_info "Amending previous wip commit..."
    "$GIT_EXE" freeze && "$GIT_EXE" commit --amend -C HEAD
else
    "$GIT_EXE" freeze -m "wip"
fi
