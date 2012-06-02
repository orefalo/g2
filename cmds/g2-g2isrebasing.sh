#!/bin/bash
#
GDIR=$("$GIT_EXE" rev-parse --git-dir 2> /dev/null)

[[ ! $GDIR ]] && echo "fatal: Not a Git Repository" && exit 1
[[ -d "$GDIR/rebase-merge" -o -d "$GDIR/rebase-apply" ]] && echo "true" || echo "false"
