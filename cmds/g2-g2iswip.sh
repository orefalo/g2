#!/bin/bash
#

remote=$1
[[ -z $1 ]] && remote=$("$GIT_EXE" g2getremote)
[[ -z $remote ]] && [[ $("$GIT_EXE" log --oneline -1 | cut -f 2 -d " " | grep -c wip) -gt 0 ]] && echo "true" && exit 0
[[ $("$GIT_EXE" log $remote..HEAD --oneline | cut -f 2 -d " " | uniq | grep -c wip) -gt 0 ]] && echo "true" || echo "false"
