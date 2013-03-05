#!/bin/bash
#
# Performs a fetch, rebase, push with a bunch of validations
#

source "$G2_HOME/cmds/color.sh"

[[ $1 == "upstream" ]] && pullOnly=true && shift

[[ $# -gt 0 ]] && echo_info "Usage: ${boldon}sync${boldoff}" && echo_info "Remember, ${boldon}sync${boldoff}hing applies to the working branch, when ${boldon}pull${boldoff}ing applies when merging feature branches" && exit 1

remote=$("$GIT_EXE" g2getremote)

$("$GIT_EXE" g2iswip $remote) || exit 1;
[[ -z $remote ]] && fatal "Please use ${boldon}g track remote/branch${boldoff} to setup tracking" && exit 2
[[ $# -ne 0 ]] && fatal "Sorry, you may only ${boldon}sync${boldoff} against the tracking remote/branch, use ${boldon}pull${boldoff} or ${boldon}push${boldoff} to deal with other branches." && exit 3
"$GIT_EXE" fetch || exit $?;
$("$GIT_EXE" g2isforced $remote)  && fatal "It appears the history of the branch was changed on the server." && error " please issue a ${boldon}g rs upstream${boldoff} or a ${boldon}g rb $remote${boldoff} to resume";
branch=$("$GIT_EXE" branch | grep "*" | sed "s/* //")
"$GIT_EXE" rev-list --left-right $branch...$remote -- 2> /dev/null > /tmp/git_upstream_status_delta
lchg=$(grep -c "^<" /tmp/git_upstream_status_delta);
rchg=$(grep -c "^>" /tmp/git_upstream_status_delta);

[[ $rchg -gt 0 ]] && { "$GIT_EXE" rebase $remote || {
        unmerged=$("$GIT_EXE" ls-files --unmerged)
        if [[ -n $unmerged ]]; then
        	echo_info "A few files need to be merged manually, please use ${boldon}g mt${boldoff} to fix conflicts."
        	echo_info " Once all conflicts are resolved, do NOT commit, but use ${boldon}g continue${boldoff} to resume."
            echo_info " Note: you may abort the merge at any time with ${boldon}g abort${boldoff}."
	    fi
        exit 1;
    }
}
[[ -z $pullOnly && $lchg -gt 0 ]] && { "$GIT_EXE" push || exit $?; }
exit 0;
