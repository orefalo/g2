#!/bin/bash
#

([[ -z "$@" ]] && ("$GIT_EXE" reset -q HEAD > /dev/null || echo "fatal: first commit must be unfrozen file by file.") || ("$GIT_EXE" reset -q HEAD -- $@ > /dev/null || "$GIT_EXE" rm -q --cached $@))

"$GIT_EXE" status -s;

