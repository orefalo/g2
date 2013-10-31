#!/bin/bash
#

source "$G2_HOME/cmds/color.sh"

echo -e "You can find all necessary help at ${boldon}http://orefalo.github.com/g2${boldoff} & ${boldon}http://www.github.com/orefalo/g2${reset}"

if [ $(uname -s) = "Darwin" ]; then
    open "http://orefalo.github.com/g2"
fi