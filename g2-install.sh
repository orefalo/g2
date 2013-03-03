#!/bin/bash
#
# Call this program to install G2

# Figure the script HOME PATH
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

OLDpwd=$PWD
cd $DIR


tips=(
"g sync adds your changes to the tip of the branch and synchronizes with the servers both ways."
"g freeze is  a handy command to litteraly freeze the state of the repository."
"g2 saves time by providing high level commands."
"g2 is generally safer than git as it prompts before destructive actions."
"run 'g setup' to configure git."
"g2 provides two letter acronyms for most commands."
"g2 eases the merge process by introducing 'g continue' and 'g abort'."
"g2 purposely provides a reduced set of commands."
"g2 enhances command line experience with auto-completion <TAB-key> and a smart prompt."
"g2 warns when the branch history was changed on the server (forced pushed)."
"g2 checks the branch freshness prior to merging and warns accordingly."
"g2 enforces a clean linear history by introducing new commands."
"g2 requires a clean state before rebasing, checking out, branching or merging."
"g2 provides guidance when it cannot perform an operation."
"g2 brings a number of friendly commands such as : panic, sync, freeze, wip."
"g2 eases branch creation. try it 'g br myBranchName'."
"g2 is just easier at undoing things: try 'g undo commit' or 'g undo merge'."
"When lost, 'g panic' is the easiest way to get you back on track."
)

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

printf "\nTip of the day: %s \n" "${tips[RANDOM % ${#tips[@]}]}"


cd $OLDpwd
