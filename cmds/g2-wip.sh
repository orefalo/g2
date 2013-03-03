#!/bin/bash
#
source "$G2_HOME/cmds/color.sh"

if [[ $("$GIT_EXE" g2iswip) = "true" ]]; then
    echo_info "info: amending previous wip commit..."
    "$GIT_EXE" g2am
else
    "$GIT_EXE" freeze -m wip
fi
