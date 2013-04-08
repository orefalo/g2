#!/bin/bash
#

source "$G2_HOME/cmds/color.sh"

if [ "$(echo "$1" | grep -e "^[0-9A-Fa-f]*$")" == "$1" ]; then
    "$GIT_EXE" checkout $*
else
    isBranch=$("$GIT_EXE" branch -a | grep -c "$1")
    [[ $isBranch -gt 0 ]] && {
        "$GIT_EXE" abort
        $("$GIT_EXE" g2haschanges) || exit 1
        g2excludes=$("$GIT_EXE" config --global --get g2.panic.excludes)
        "$GIT_EXE" checkout "$@" && "$GIT_EXE" clean -fdx $g2excludes
        exit $?;
    }

    echo_info "There is no branch named '$1', you may want to run 'g fetch <remote_name>' to refresh from the server"
    echo_info "If you are trying to revert a file, consider 'g undo <file>'"
fi