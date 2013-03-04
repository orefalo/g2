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

source "$G2_HOME/cmds/color.sh"

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
	echo -e "G2 Usage:
	${boldon}abort${boldoff} - aborts any rebase/merge
	${boldon}am <?-f>${boldoff} - amends last commit with staging area
	${boldon}br <?-D> <?-M> <?branch>${boldoff} - list or create branches
	${boldon}bs${boldoff} - bisect, aka bug finder
	${boldon}co <branch>${boldoff} - switches branch (either local/remote)
	${boldon}continue${boldoff} - resumes a conflict resolution
	${boldon}cp <commit>${boldoff} - cherry-pick
	${boldon}ci <?params...>${boldoff} - commit
	${boldon}clone <url>${boldoff} - clone a remote repository
	${boldon}df/dt <?params...> <file>${boldoff} - compares files
	${boldon}fetch${boldoff} - gets changes sitting on the server
	${boldon}freeze/unfreeze <?-m comment> <?file>${boldoff} - freeze/unfreeze files
	${boldon}gc${boldoff} - garbage collects: run fsck & gc
	${boldon}gp${boldoff} - grep
	${boldon}gui${boldoff} - launches the GUI
	${boldon}ig <file>${boldoff} - adds to gitignore & removes from source control
	${boldon}init <folder>${boldoff} - init a repository
	${boldon}key <?-gen>${boldoff} - displays/generates your ssh public key
	${boldon}mg <?params...> <branch>${boldoff} - merge
	${boldon}mt <?params...>${boldoff} - fixes conflicts by opening a visual mergetool
	${boldon}mv${boldoff} - move (rename) a file
	${boldon}lg${boldoff} - displays commit log
	${boldon}ls <?params...>${boldoff} - list files under source control
	${boldon}panic${boldoff} - gets you back on HEAD, cleans all untracked files
	${boldon}pull/push <?opts> <remote> <branch>${boldoff} - deals with other branches
	${boldon}rb <?params...> <branch> or <upstream>${boldoff} - rebase
	${boldon}rm <params...>${boldoff} - remove files
	${boldon}rs <params...>${boldoff} - reset branch status
	${boldon}rs upstream${boldoff} - resets branch to upstream state
	${boldon}rt <?params...>${boldoff} - git remotes management
	${boldon}rv <commit>${boldoff} - reverts commits
	${boldon}setup${boldoff} - configures user, key, editor, tools
	${boldon}sh <?-deep>${boldoff} - show commit contents
	${boldon}sm <?params...>${boldoff} - submodule
	${boldon}ss <?params>${boldoff} - stash
	${boldon}st <?params...>${boldoff} - status
	${boldon}sync <?upstream>${boldoff} - syncs working branch: fetch, rebase & push
	${boldon}tg${boldoff} - tag
	${boldon}track <?upstream_branch>${boldoff} - shows/set tracking
	${boldon}undo <file>|commit <hash>|merge${boldoff} - reverts changes
	${boldon}wip/unwip${boldoff} - save/restore work in progress to branch"

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
    "df" ""
    "diff" ""
    "dt" ""
    "difftool" ""
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

