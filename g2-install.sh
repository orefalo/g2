#!/bin/bash
#
# Call this program to install G2

[ `basename $BASH` != "bash" ] && echo "G2 only supports bash at the moment, thank you for trying." && exit 1

# Figure the script HOME PATH
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

OLDpwd=$PWD
cd $DIR

export G2_HOME=$DIR

source ./cmds/color.sh

tips=(
"${boldon}g sync${boldoff} adds your changes to the tip of the branch and synchronizes with the servers both ways."
"${boldon}g freeze${boldoff} is  a handy command to freeze all the changes in one shot."
"${boldon}g2${boldoff} saves time by providing high level commands."
"${boldon}g2${boldoff} is safer than git as it prompts before destructive actions."
"run ${boldon}g setup${boldoff} to configure git."
"${boldon}g2${boldoff} provides two letter acronyms for most commands."
"${boldon}g2${boldoff} eases the merge process by introducing ${boldon}g continue${boldoff} and ${boldon}g abort${boldoff}."
"${boldon}g2${boldoff} purposely provides a reduced set of commands."
"${boldon}g2${boldoff} enhances command line experience with auto-completion <TAB-key> and a smart prompt."
"${boldon}g2${boldoff} warns when the branch history was changed on the server (forced pushed)."
"${boldon}g2${boldoff} checks the branch freshness prior to merging and warns accordingly."
"${boldon}g2${boldoff} enforces a clean linear history by introducing new commands."
"${boldon}g2${boldoff} requires a clean state before rebasing, checking out, branching or merging."
"${boldon}g2${boldoff} provides guidance when it cannot perform an operation."
"${boldon}g2${boldoff} brings a number of friendly commands such as : ${boldon}panic, sync, freeze, wip${boldoff}."
"${boldon}g2${boldoff} eases branch creation. try it ${boldon}g br myBranchName${boldoff}."
"Need to display your ssh public key? try ${boldon}g key${boldoff}."
"${boldon}g2${boldoff} is just easier at undoing things: try ${boldon}g undo commit${boldoff} or ${boldon}g undo merge${boldoff}."
"When lost, ${boldon}g panic${boldoff} is the easiest way to get back on track."
"Use ${boldon}g track${boldoff} to review how local/remote branches are setup."
"Unlike git, ${boldon}g2${boldoff} actions only apply to the current branch.");

echo -n -e "Installing ${boldon}G2${boldoff}.."

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

echo -e "${boldon}Tip of the day${boldoff}: ${tips[RANDOM % ${#tips[@]}]} ${reset}"


cd $OLDpwd
