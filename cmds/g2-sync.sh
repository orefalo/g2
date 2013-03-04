#!/bin/bash
#
# Performs a fetch, rebase, push with a bunch of validations
#

source "$G2_HOME/cmds/color.sh"

[[ $1 == "upstream" ]] && pullOnly=true && shift

[[ $# -gt 0 ]] && echo_fatal "Usage: <sync>" && echo_fatal "Remember, <sync>hing applies to the working branch, when <pull>ing applies when merging feature branches" && exit 1

remote=$("$GIT_EXE" g2getremote)

$("$GIT_EXE" g2iswip $remote) || exit 1;
[[ -z $remote ]] && echo_fatal "fatal: please use <track> to setup the remote/branch to track with" && exit 2
[[ $# -ne 0 ]] && echo_fatal "fatal: sorry, you may only <sync> against the tracking remote/branch, use <pull> or <push> to deal with other branches." && exit 3
"$GIT_EXE" fetch || exit $?;
$("$GIT_EXE" g2isforced $remote)  && echo_fatal "abort: it appears the history of the branch was changed on the server." && echo_fatal " please issue a <g rs upstream> or a <g rb $remote> to resume" && exit 1;
branch=$("$GIT_EXE" branch | grep "*" | sed "s/* //")
"$GIT_EXE" rev-list --left-right $branch...$remote -- 2> /dev/null > /tmp/git_upstream_status_delta
lchg=$(grep -c "^<" /tmp/git_upstream_status_delta);
rchg=$(grep -c "^>" /tmp/git_upstream_status_delta);

[[ $rchg -gt 0 ]] && { "$GIT_EXE" rebase $remote || {
        unmerged=$("$GIT_EXE" ls-files --unmerged)
        if [[ -n $unmerged ]]; then
        	echo_info "A few files need to be merged manually, please use <g mt> to fix conflicts."
        	echo_info " Once all conflicts are resolved, do NOT commit, but use <g continue> to resume."
            echo_info " Note: you may abort the merge at any time with <g abort> ."
	    fi
        exit 1;
    }
}
[[ -z $pullOnly && $lchg -gt 0 ]] && { "$GIT_EXE" push || exit $?; }
exit 0;
