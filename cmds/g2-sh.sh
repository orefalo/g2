#!/bin/bash
#

[[ $1 == "-deep" ]] && shift || flag="--name-only"
[[ -z $1 ]] && br="HEAD" || br=$1
[[ -n $flag ]] && { "$GIT_EXE" show --pretty="format:" $flag $br | sort | uniq; } || "$GIT_EXE" show $br;

