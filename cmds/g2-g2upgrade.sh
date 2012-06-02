#!/bin/bash
#

read -p "Do you really want to upgrade g2 (y/n)? " -n 1 -r
echo
[[ $REPLY = [yY]* ]] && {

    [[ -f /etc/g2/g2-install.sh ]] && RPATH="/etc/g2"
    [[ -f ./g2-install.sh ]] && RPATH="."

    [[ -z $RPATH ]] && echo "G2 not found, please cd to the install folder" && exit 1

    cd "$RPATH"
    "$GIT_EXE" fetch
    g2excludes=$("$GIT_EXE" config --global --get g2.panic.excludes)
    "$GIT_EXE" reset --hard origin/master && "$GIT_EXE clean -fdx $g2excludes"

    echo "Congratulations, please close this bash session and open a new one"
}