#!/bin/bash
#
# This command is used to resume a conflict, either rebase or merge
#  it will smartly do a rebase --skip when necessary

state=$("$GIT_EXE" g2brstatus)

[[ $state = "rebase" ]] && {

    action="--continue"
    if git diff-index --quiet HEAD --; then
	    echo "The last commit brings no significant changes -- skipping"
		action="--skip"
    fi

    "$GIT_EXE" rebase $action 2> /dev/null

}

[[ $state = "merge" ]] && {
    # Count the number of unmerged files
    count=$("$GIT_EXE" ls-files --unmerged | wc -l)
    [[ $count -ne 0 ]] && echo "I am afraid you still have unmerged files, please run <g mt> to resolv conflicts" ||"$GIT_EXE" commit
}