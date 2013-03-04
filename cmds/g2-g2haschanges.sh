#!/bin/bash
#
# returns 0 if no pending changes, 1 if any (workspace or index)

source "$G2_HOME/cmds/color.sh";

if [[ $("$GIT_EXE" diff --cached --numstat | wc -l) -ne 0 ]]; then
    echo_fatal "fatal: you have changes in the staging area, please commit them ${boldon}g ci -m mymessage${boldooff} or save them as a work in progress ${boldon}g wip${boldooff}.";
    exit 1;
fi

if [[ $("$GIT_EXE" diff --numstat | wc -l) -ne 0 ]]; then
    echo_fatal "fatal: some files were modified, either commit then ${boldon}g ci -m mymessage${boldooff}, save them as a work in progress ${boldon}g wip${boldooff} or discard them ${boldon}g panic${boldoff}.";
    exit 1;
fi

exit 0;
