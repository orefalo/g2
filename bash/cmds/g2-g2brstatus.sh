#!/bin/bash
#
# Internal command that return "rebase", "merge" or "false" depending on the repository status

source "$G2_HOME/cmds/color.sh"

GDIR=$("$GIT_EXE" rev-parse --git-dir 2> /dev/null)

[[ ! $GDIR ]] && error "Not a Git Repository"
[[ -d "$GDIR/rebase-merge" || -d "$GDIR/rebase-apply" ]] && echo "rebase" && exit 0
[[ -f "$GDIR/MERGE_HEAD" ]] && echo "merge" && exit 0
echo "false"
