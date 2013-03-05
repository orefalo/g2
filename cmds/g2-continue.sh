#!/bin/bash
#
# This command is used to resume conflict resolution,
# Unlike git, it detects what needs to be resumed: rebase or merge
#  and smartly run the right command

source "$G2_HOME/cmds/color.sh"

state=$("$GIT_EXE" g2brstatus)

if [[ $state = "rebase" ]]; then
    action="--continue"
    if git diff-index --quiet HEAD --; then
	    echo_info "The last commit brings no significant changes -- automatically skipping"
		action="--skip"
    fi
    "$GIT_EXE" rebase $action 2> /dev/null
fi

[[ $state = "merge" ]] && {
    # Count the number of unmerged files
    count=$("$GIT_EXE" ls-files --unmerged | wc -l)
    [[ $count -ne 0 ]] && fatal "Hey! you still have unmerged files, please run ${boldon}g mt${boldoff} to resolve conflicts" ||"$GIT_EXE" commit
}