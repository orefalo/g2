#!/bin/bash
#

source "$G2_HOME/cmds/color.sh"

([[ -z "$@" ]] && ("$GIT_EXE" reset -q HEAD > /dev/null || fatal "The first commit must be unfrozen ${boldon}file by file${boldoff}. Sorry about that...") || ("$GIT_EXE" reset -q HEAD -- $@ > /dev/null || "$GIT_EXE" rm -q --cached $@))
"$GIT_EXE" status -s;

