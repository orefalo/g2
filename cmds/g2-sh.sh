#!/bin/bash
#
# Displays the details of a commit, can take a hash as parameter
#  use -deep to display contents

"$GIT_EXE" rev-parse || exit 1

[[ $1 == "-deep" ]] && shift || flag="--name-only"
[[ -z $1 ]] && br="HEAD" || br=$1
[[ -n $flag ]] && { "$GIT_EXE" show --pretty="format:" $flag $br | sort | uniq; } || "$GIT_EXE" show $br;

