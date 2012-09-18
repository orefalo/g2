#!/bin/bash
#
# Call this program to install G2

# Figure the script HOME PATH
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

OLDpwd=$PWD
cd $DIR

echo -n "Installing G2.."

source ./g2-completion.sh
echo -n "."
source ./g2-config.sh
echo -n "."
source ./g2.sh
echo -n "."
source ./g2-prompt.sh

alias g=__g2_eval;
alias git=__g2_eval;

echo " Enjoy!"

cd $OLDpwd
