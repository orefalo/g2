#!/bin/bash
#

isWIP() {
remote=$("$GIT_EXE" g2getremote)
if [[ -z $remote ]]; then
    [[ $("$GIT_EXE" log --oneline -1 2>/dev/null | cut -f 2 -d " " | grep -c wip) -gt 0 ]] && wip=1
else
    [[ $("$GIT_EXE" log $remote..HEAD --oneline 2>/dev/null | cut -f 2 -d " " | uniq | grep -c wip) -gt 0 ]] && wip=1
fi
wip=0
}

isWIPå
if [[ $wip -eq 0 ]]; then
    echo_fatal "fatal: there is nothing to <unwip>..."
else
    "$GIT_EXE" log -n 1 | grep -q -c "wip" && "$GIT_EXE" reset HEAD~1
fi
