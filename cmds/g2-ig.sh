#!/bin/bash
#
# Ignores a file and automatically adds it to gitignore & removes from source control

[[ -z "$@" ]] && echo "usage: ignore [file]" || { ([ ! -e .gitignore ] && touch .gitignore); echo "$GIT_PREFIX/$1" >> .gitignore && echo "Ignoring file $1" && "$GIT_EXE" rm --cached "$GIT_PREFIX/$@" > /dev/null 2>&1 && "$GIT_EXE" st; }