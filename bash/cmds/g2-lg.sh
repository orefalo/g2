#!/bin/bash
#

[[ $# -eq 0 ]] && ("$GIT_EXE" log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative
true;) || "$GIT_EXE" log "$@"
