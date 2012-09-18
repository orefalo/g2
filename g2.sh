#!/bin/bash
#
# G2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# 
# G2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
#
# - Olivier Refalo

GIT_EXE=$(which git)
[[ -z "$GIT_EXE" ]] && echo "Sorry git not found in the PATH";
export GIT_EXE

function __g2_contains() {
	local n=$#
	local value=${!n}
	for ((i=1;i < $#;i=i+2)) {
		[[ "${!i}" == "${value}" ]] && (
			let i++
			local ex="${!i}"
			[[ -n $ex ]] && echo $ex || echo $value
			break);
	}
}

function __g2_usage() {
	cat << EOF
Usage:
	abort - aborts any rebase/merge
	am <?-f> - amends last commit with staging area
	br <?-D> <?-M> <?branch> - list or create branches
	bs - bisect
	co <branch> - switches branch (either local/remote)
	continue - resumes a conflict resolution
	cp <commit> - cherry-pick
	ci <?params...> - commit
	clone <url> - clone a remote repository
	df/dt <?params...> <file> or <upstream> - compares files
	fetch - synchronizes remote branches
	freeze/unfreeze <?-m comment> <?file> - freeze/unfreeze files
	gc - garbage collects: run fsck & gc
	gp - grep
	gui - launches the GUI
	ig <file> - adds to gitignore & removes from source control
	init <folder> - init a repository
	key <?-gen> - displays/generates your ssh public key
	mg <?params...> <branch> - merge
	mt <?params...> - fixes conflicts by opening a visual mergetool
	mv - move (rename) a file
	lg - displays commit log
	ls <?params...> - list files under source control
	panic - gets you back on HEAD, cleans all untracked files
	pull/push <?opts> <remote> <branch> - deals with other branches
	rb <?params...> <branch> or <upstream> - rebase
	rm <params...> - remove
	rs <params...> - reset
	rs upstream - resets branch to upstream state
	rt <?params...> - remote
	rv <commit> - revert
	setup - configures user, key, editor, tools
	sh <?-deep> - show commit contents
	sm <?params...> - submodule
	ss <?params> - stash
	st <?params...> - status
	sync <?upstream> - syncs working branch: fetch, rebase & push
	tg - tag
	track <?upstream_branch> - shows/set tracking
	undo <file>|commit <hash>|merge - reverts changes
	wip/unwip - save/restore work in progress to branch
EOF
	return 0;
}

function __g2_eval() {
	[[ $# -eq 0 ]] && __g2_usage || (
	local A=(
    "abort" ""
    "add" "g2add"
    "am" "g2am"
    "br" ""
    "branch" "br"
    "bs" ""
    "bisect" "bs"
    "clone" ""
    "ci" ""
    "commit" "ci"
    "co" ""
    "continue" ""
    "checkout" "co"
    "cp" ""
    "cherry-pick" "cp"
    "df" "g2diff"
    "diff" "g2diff"
    "dt" ""
    "difftool" "dt"
    "fetch" ""
    "freeze" ""
    "gc" "g2gc"
    "gp" ""
    "grep" "gp"
    "gui" ""
    "help" "g2help"
    "ig" ""
    "init" ""
    "key" ""
    "lg" ""
    "log" "lg"
    "ls" ""
    "ls-files" "ls"
    "mg" ""
    "merge" "mg"
    "mt" ""
    "mergetool" "mt"
    "mv" ""
    "panic" ""
    "pull" "g2pull"
    "push" "g2push"
    "rb" ""
    "rebase" "rb"
    "refresh" ""
    "rt" ""
    "remote" "rt"
    "rm" ""
    "rs" ""
    "reset" "rs"
    "rv" "revert"
    "revert" ""
    "setup" ""
    "sh" ""
    "show" "sh"
    "sm" ""
    "submodule" "sm"
    "ss" ""
    "stash" "ss"
    "st" ""
    "status" "st"
    "sync" ""
    "tg" ""
    "tag" "tg"
    "track" ""
    "undo" ""
    "unfreeze" ""
    "unwip" ""
    "version" "g2version"
    "wip" ""
	 );
	local cmd=$(__g2_contains "${A[@]}" $1 )
	if [[ -z $cmd ]]; then
		echo "fatal: Invalid command!"
		__g2_usage
	else
		declare -a p=("$@")
		p[0]=$cmd
		"$GIT_EXE" "${p[@]}";
	fi
	);
}

