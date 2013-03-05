#!/bin/bash
#
# returns 0 if no pending changes, 1 if any (workspace or index)

source "$G2_HOME/cmds/color.sh";

if [[ $("$GIT_EXE" diff --cached --numstat | wc -l) -ne 0 ]]; then
    error "There are changes in the staging area, please commit them ${boldon}g ci -m mymessage${boldooff} or save them as a work in progress ${boldon}g wip${boldooff}.";
fi

if [[ $("$GIT_EXE" diff --numstat | wc -l) -ne 0 ]]; then
    error "Some files were modified, either commit then ${boldon}g ci -m mymessage${boldooff}, save them as a work in progress ${boldon}g wip${boldooff} or discard them ${boldon}g panic${boldoff}.";
fi

exit 0;
