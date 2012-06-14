#!/bin/bash
#

[[ $1 == "upstream" ]] && pullOnly=true && shift

[[ $# -gt 0 ]] && echo "Usage: <sync>" && echo "Remember, <sync>hing applies to the working branch, when <pull>ing applies when merging feature branches" && exit 1

remote=$("$GIT_EXE" g2getremote)

[[ $("$GIT_EXE" g2iswip $remote) = "true" ]] && echo "fatal: sorry, wip commits shall not be synced. Please <unwip>, then <freeze> & commit <ci>" && exit 1;
[[ -z $remote ]] && echo "fatal: please use <track> to setup the remote/branch to track with" && exit 2
[[ $# -ne 0 ]] && echo "fatal: sorry, you may only <sync> against the tracking remote/branch, use <pull> or <push> to deal with other branches." && exit 3
"$GIT_EXE" fetch || exit $?;
[[ $("$GIT_EXE" g2isforced $remote) = "true" ]] && 
	  echo "abort: it appears the history of the branch was changed on the server." &&
	  echo " please issue a <g rs upstream> or a <g rb $remote> to resume" &&
	  exit 1;
branch=$("$GIT_EXE" branch | grep "*" | sed "s/* //")
"$GIT_EXE" rev-list --left-right $branch...$remote -- 2> /dev/null > /tmp/git_upstream_status_delta || exit $?
lchg=$(grep -c "^<" /tmp/git_upstream_status_delta);
rchg=$(grep -c "^>" /tmp/git_upstream_status_delta);
[[ $rchg -gt 0 ]] && { "$GIT_EXE" rebase $remote || {
        unmerged=$("$GIT_EXE" ls-files --unmerged)
        if [[ -n $unmerged ]]; then
        	echo "info: some files need to be merged manually, please use <g mt> to fix conflicts."
        	echo " Once all resolved, do NOT commit, but use <g continue> to resume."
            echo " Note that you may <abort> at any time"
	    fi
        exit 1;
    }
}
[[ -z $pullOnly && $lchg -gt 0 ]] && { "$GIT_EXE" push || exit $?; }
exit 0;
