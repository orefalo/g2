#!/bin/bash
#
# Displays list of all branches (local and upstream)
#
# Can also delete, rename and create branches (wizards)

source "$G2_HOME/cmds/color.sh"

hasDMFlag() {
    local opt
    while getopts ":dDmM:" opt; do
        case $opt in
            d|D|m|M)
					flag="true"; return ;;
			\?)
					echo_info "Usage: g br <?-D> <?-M> <?branch>" >&2
					flag="exit"; return ;;
        esac
    done
    flag="false"
}

br_status() {
    "$GIT_EXE" for-each-ref --format="%(refname:short) %(upstream:short)" refs/heads |  \
    while read local remote
    do
        [[ -z $remote ]] && continue
        "$GIT_EXE" rev-list --left-right ${local}...${remote} -- 2> /dev/null > /tmp/git_upstream_status_delta || continue
        LEFT_AHEAD=$(grep -c "^<" /tmp/git_upstream_status_delta)
        RIGHT_AHEAD=$(grep -c "^>" /tmp/git_upstream_status_delta)
        echo_info "$local (ahead $LEFT_AHEAD) | (behind $RIGHT_AHEAD) $remote"
        echo
    done
}

if [[ $# -eq 0 ]]; then
    "$GIT_EXE" branch -a
    echo "-------"
    br_status
else
	hasDMFlag "$@"
	[[ $flag = "exit" ]] && exit 1;
    [[ $flag = "true" ]] && { "$GIT_EXE" branch "$@"; exit $?; }
    $("$GIT_EXE" g2haschanges) || exit 1;

    shift $(( OPTIND - 1 ))
    branch="${1:-/}"

    [[ $branch = */* ]] && error "${boldon}$branch${boldoff} is not a valid branch name"
    [[ -n $("$GIT_EXE" branch | grep "^$branch$") ]] && error "branch ${boldon}$branch${boldoff} already exist"

    remote=$("$GIT_EXE" g2getremote)
    [[ -n $remote ]] && {

        IFS=/ read -a rmt <<< "$remote"
        remote=${rmt[0]}
        read -p "Would you like to create the remote $remote/$branch on the server (y/n)? " -n 1 -r
        echo
        [[ $REPLY == [yY]* ]] && {
            "$GIT_EXE" branch "$branch" && "$GIT_EXE" checkout "$branch" && "$GIT_EXE" push $remote $branch && "$GIT_EXE" fetch $remote && "$GIT_EXE" track "$remote/$branch"
            exit $?
        }
    }

    "$GIT_EXE" branch "$branch" && "$GIT_EXE" checkout "$branch"
    exit $?
fi
