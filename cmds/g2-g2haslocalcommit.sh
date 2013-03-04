#!/bin/bash
#
# returns 1 local commits (commit not on the server), 0 if not, 2 no remote

remote=$("$GIT_EXE" g2getremote)
[[ -z "$remote" ]] && exit 2
[[ $("$GIT_EXE" log $remote..HEAD --oneline | wc -l) -eq 0 ]] && exit 0
exit 1
