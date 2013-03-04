#!/bin/bash
#
# This command is used to resume conflict resolution,
# Unlike git, it detects what needs to be resumed: rebase or merge
#  and smartly run the right command

source "$G2_HOME/cmds/color.sh"

state=$("$GIT_EXE" g2brstatus)

[[ $state = "rebase" ]] && {

    action="--continue"
    if git diff-index --quiet HEAD --; then
	    echo_info "The last commit brings no significant changes -- automatically skipping"
		action="--skip"
    fi

    "$GIT_EXE" rebase $action 2> /dev/null

}

[[ $state = "merge" ]] && {
    # Count the number of unmerged files
    count=$("$GIT_EXE" ls-files --unmerged | wc -l)
    [[ $count -ne 0 ]] && echo_fatal "I am afraid you still have unmerged files, please run <g mt> to resolve conflicts" ||"$GIT_EXE" commit
}