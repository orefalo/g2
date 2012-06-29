#!/bin/bash
#
# Internal command that return "rebase", "merge" or "false"

GDIR=$("$GIT_EXE" rev-parse --git-dir 2> /dev/null)

[[ ! $GDIR ]] && echo "fatal: Not a Git Repository" && exit 1
[[ -d "$GDIR/rebase-merge" || -d "$GDIR/rebase-apply" ]] && echo "rebase" && exit 0
[[ -f "$GDIR/MERGE_HEAD" ]] && echo "merge" && exit 0
echo "false"
