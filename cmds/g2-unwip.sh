#!/bin/bash
#
source "$G2_HOME/cmds/color.sh"

[[ $("$GIT_EXE" g2iswip) = "false" ]] && echo_fatal "fatal: there is nothing to <unwip>..." || ("$GIT_EXE" log -n 1 | grep -q -c wip && "$GIT_EXE" reset HEAD~1)
