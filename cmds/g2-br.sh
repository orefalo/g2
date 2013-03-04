#!/bin/bash
#
# Displays list of all branches (local and upstream)
#
# Can also delete, rename and create branches (wizards)

hasDMFlag() {
    local opt
    while getopts ":dDmM:" opt; do
        case $opt in
            d|D|m|M)
					echo "true"; return ;;
			\?)
					echo "Usage: g br <?-D> <?-M> <?branch>" >&2
					echo "exit"; return ;;
        esac
    done
    echo "false"
}

br_status() {
    "$GIT_EXE" for-each-ref --format="%(refname:short) %(upstream:short)" refs/heads |  \
    while read local remote
    do
        [[ -z $remote ]] && continue
        "$GIT_EXE" rev-list --left-right ${local}...${remote} -- 2> /dev/null > /tmp/git_upstream_status_delta || continue
        LEFT_AHEAD=$(grep -c "^<" /tmp/git_upstream_status_delta)
        RIGHT_AHEAD=$(grep -c "^>" /tmp/git_upstream_status_delta)
        echo "$local (ahead $LEFT_AHEAD) | (behind $RIGHT_AHEAD) $remote"
        echo
    done
}

if [[ $# -eq 0 ]]; then
    "$GIT_EXE" branch -a
    echo "-------"
    br_status
else
	flag=$(hasDMFlag "$@")
	[[ $flag = "exit" ]] && exit 1;
    [[ $flag = "true" ]] && { "$GIT_EXE" branch "$@"; exit $?; }
    $("$GIT_EXE" g2haschanges) || exit 1;

    shift $(( OPTIND - 1 ))
    branch="${1:-/}"

    [[ $branch = */* ]] && echo "fatal: $branch is not a valid branch name" && exit 1
    [[ -n $("$GIT_EXE" branch | grep "^$branch$") ]] && echo "fatal: branch $branch already exist" && exit 1

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
