#!/bin/bash
#
source "$G2_HOME/cmds/color.sh"

isWIP() {
remote=$("$GIT_EXE" g2getremote)
if [[ -z $remote ]]; then
    [[ $("$GIT_EXE" log --oneline -1 2>/dev/null | cut -f 2 -d " " | grep -c wip) -gt 0 ]] && wip=1
else
    [[ $("$GIT_EXE" log $remote..HEAD --oneline 2>/dev/null | cut -f 2 -d " " | uniq | grep -c wip) -gt 0 ]] && wip=1
fi
wip=0
}

if [[ $wip -eq 1 ]]; then
    echo_info "Amending previous wip commit..."
    "$GIT_EXE" g2am
else
    "$GIT_EXE" freeze -m "wip"
fi
