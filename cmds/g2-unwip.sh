#!/bin/bash
#

[[ $("$GIT_EXE" g2iswip) = "false" ]] && echo "fatal: there is nothing to <unwip>..." || ("$GIT_EXE" log -n 1 | grep -q -c wip && "$GIT_EXE" reset HEAD~1)
