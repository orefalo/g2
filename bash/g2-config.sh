#!/bin/bash 
#
# G2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# 
# G2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
#
# - Olivier Refalo

GIT_EXE=$(which git)
[[ -z "$GIT_EXE" ]] && echo "Sorry, git not found in the PATH";
export GIT_EXE

save_config() {
    # Read current settings
    nameinput=$("$GIT_EXE" config --global --get user.name);
    emailinput=$("$GIT_EXE" config --global --get user.email);
    editor=$("$GIT_EXE" config --global --get core.editor);

    mt_alias=$("$GIT_EXE" config merge.tool)
    if [[ -n $mt_alias ]]; then
        existCode=$("$GIT_EXE" config mergetool.${mt_alias}.trustExitCode)
        cmdLine=$("$GIT_EXE" config mergetool.${mt_alias}.cmd)
    fi

    dt_alias=$("$GIT_EXE" config diff.tool)
    if [[ -n $dt_alias ]]; then
        cmdLine_dt=$("$GIT_EXE" config difftool.${dt_alias}.cmd)
    fi

    g2count=$("$GIT_EXE" config --global --bool --get g2.prompt.countfiles)
    g2excludes=$("$GIT_EXE" config --global --get g2.panic.excludes)
}

apply_config() {
    [[ -n $nameinput ]] && "$GIT_EXE" config --global user.name "$nameinput";
    [[ -n $emailinput ]] && "$GIT_EXE" config --global user.email "$emailinput";
    [[ -n $editor ]] && "$GIT_EXE" config --global core.editor "$editor" || "$GIT_EXE" config --global core.editor "vi";
    [[ -n $mt_alias ]] && "$GIT_EXE" config --global merge.tool "$mt_alias";
    [[ -n $mt_alias && -n $existCode ]] && "$GIT_EXE" config --global mergetool.${mt_alias}.trustExitCode "$existCode";
    [[ -n $mt_alias && -n $cmdLine ]] && "$GIT_EXE" config --global mergetool.${mt_alias}.cmd "$cmdLine";
    [[ -n $dt_alias ]] && "$GIT_EXE" config --global diff.tool "$dt_alias";
    [[ -n $dt_alias && -n $cmdLine_dt ]] && "$GIT_EXE" config --global difftool.${dt_alias}.cmd "$cmdLine_dt";
    [[ -n $g2count ]] && "$GIT_EXE" config --global g2.prompt.countfiles $g2count
    [[ -n $g2excludes ]] && "$GIT_EXE" config --global g2.panic.excludes "$g2excludes"
}

# Avoid errors with multiple concurrent sessions
LOCKFILE=$(which lockfile)
[[ -n $LOCKFILE ]] && lockfile -2 -r 3 /tmp/git-config.lock

save_config
[[ -f ~/.gitconfig && $(grep "#G2 - https://github.com/orefalo/g2" ~/.gitconfig | wc -l ) -eq 0 ]] && mv -f ~/.gitconfig ~/.gitconfig.pre-g2

echo "#G2 - https://github.com/orefalo/g2" > ~/.gitconfig
apply_config

$GIT_EXE config --global core.excludesfile ~/.gitignore_global

# SHORT ALIASES -----------
"$GIT_EXE" config --global alias.dt difftool
"$GIT_EXE" config --global alias.df diff
"$GIT_EXE" config --global alias.mt mergetool
"$GIT_EXE" config --global alias.ls ls-files
"$GIT_EXE" config --global alias.bs bisect
"$GIT_EXE" config --global alias.gp grep
"$GIT_EXE" config --global alias.tg tag
"$GIT_EXE" config --global alias.rt remote
"$GIT_EXE" config --global alias.st status
"$GIT_EXE" config --global alias.ss stash
"$GIT_EXE" config --global alias.sm submodule
"$GIT_EXE" config --global alias.server "daemon --verbose --export-all --base-path=.git --reuseaddr --strict-paths .git/"

#"$GIT_EXE" config --global alias.alias "!"$GIT_EXE" config --list | grep 'alias\\.' | sed 's/alias\\.\\([^=]*\\)=\\(.*\\)/\\1\\: \\2/' | sort"


#TODO
# inline freeze, undo, co

# tells what branch have merged with master
#"$GIT_EXE" config --global alias.ismerged 'branch -a --merged master'

# SETTINGS ----------------
"$GIT_EXE" config --global color.branch auto
"$GIT_EXE" config --global color.diff auto
"$GIT_EXE" config --global color.interactive auto
"$GIT_EXE" config --global color.status auto

# For windows, use these default settings
if [[ $(uname -a) = MINGW* ]]; then
	"$GIT_EXE" config --global core.autocrlf true
	"$GIT_EXE" config --global core.symlinks false
	"$GIT_EXE" config --global pack.packSizeLimit 2g
	PREPROCESSOR="source "
        cmds=$(ls --color=no $PWD/cmds/g2*.sh)
else
	"$GIT_EXE" config --global core.autocrlf input
	PREPROCESSOR=""
	cmds=$(ls $PWD/cmds/g2*.sh)
fi

"$GIT_EXE" config --global core.safecrlf warn
"$GIT_EXE" config --global push.default current
"$GIT_EXE" config --global mergetool.keepBackup false

# Figure the script HOME PATH
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
cd $DIR

# Process all aliases dynamically
for cmd in $cmds
do
    al=$(basename $cmd)
    al=${al/g2-/}
    al=${al/\.sh/}
    al=${al/ /}
    "$GIT_EXE" config --global "alias.$al" "!$PREPROCESSOR$cmd"
done

[[ -n $LOCKFILE ]] && rm -f /tmp/git-config.lock && unset LOCKFILE
