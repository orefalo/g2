#!/bin/bash
#

"$GIT_EXE" rev-parse || exit 1

source "$G2_HOME/cmds/color.sh"

if [[ $# -eq 1 ]]; then
    [[ "$1" != */* ]] && error "${boldon}$1${boldoff} is not an upstream branch (ie. origin/xxx)."

    "$GIT_EXE"  ls-remote --exit-code . "$1"  &> /dev/null
    if [ $? -ne 0 ]; then
	  
      read -p "Remote branch not found, would you like to refresh from the server (y/n)? " -n 1 -r;
      echo
      [[ $REPLY == [yY]* ]] && "$GIT_EXE" fetch && echo "Good, now try the command again";
      exit $?;
    fi

    "$GIT_EXE" branch --set-upstream-to "$1"
else
    echo -e -n "${greenf}"
    "$GIT_EXE" for-each-ref --format="local: %(refname:short) <--sync--> remote: %(upstream:short)" refs/heads
    echo -e -n "${reset}"
    echo -e "${boldon}--Remotes------------${boldoff}"
    echo -e -n "${yellowf}"
    "$GIT_EXE" remote -v
    echo -e -n "${reset}"
fi
