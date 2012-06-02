#!/bin/bash
#

read -p "Do you really want to upgrade g2 (y/n)? " -n 1 -r
echo
[[ $REPLY = [yY]* ]] && {
    cd /etc/g2
    "$GIT_EXE" fetch
    "$GIT_EXE" reset origin/master
    echo "Congratulations, please close this bash session and open a new one"
}