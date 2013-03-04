#!/bin/bash
# returns 1 if there is a wip commit at the tip of the branch, 0 if not
# Typical usage $("$GIT_EXE" g2iswip) || exit 1

source "$G2_HOME/cmds/color.sh"

error() {
    echo_fatal "fatal: Work In Progress (wip) detected, please run <g unwip> to resume progress first.";
    exit 1;
}

remote=$1;
[[ -z $1 ]] && remote=$("$GIT_EXE" g2getremote);

wip=0;
if [[ -z $remote ]]; then
    [[ $("$GIT_EXE" log --oneline -1 2>/dev/null | cut -f 2 -d " " | grep -c wip) -gt 0 ]] && wip=1;
else
    [[ $("$GIT_EXE" log $remote..HEAD --oneline 2>/dev/null | cut -f 2 -d " " | uniq | grep -c wip) -gt 0 ]] && wip=1;
fi

[[ $wip -eq 1 ]] && error || exit 0;
