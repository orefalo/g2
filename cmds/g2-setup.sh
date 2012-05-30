#!/bin/bash
#

echo "Running G2 setup, press <ENTER> to select the default setting:"

## USER NAME
nameinput=$("$GIT_EXE" config --global --get user.name)
if [[ -z $nameinput ]]; then
    read -p "Please input your full name: " -e nameinput
else
    read -p "Please input your full name ($nameinput): " -e nameinput
fi

## EMAIL
emailinput=$("$GIT_EXE" config --global --get user.email);
if [[ -z $emailinput ]]; then
    read -p "Please input your email: " -e emailinput
else
    read -p "Please input your email ($emailinput): " -e emailinput
fi

## EDITOR
editor=$("$GIT_EXE" config --global --get core.editor)
if [[ -z "$editor" ]]; then
    read -p "Please input your editor: " -e editor
else
    read -p "Please input your editor ($editor): " -e editor
fi

g2count=$("$GIT_EXE" config --global --bool --get g2.prompt.countfiles)
if [[ -z $g2count ]]; then
    read -p "Count files in the bash prompt? (true)" -e g2count
else
    read -p "Count files in the bash prompt? ($g2count): " -e g2count
fi

g2excludes=$("$GIT_EXE" config --global --get g2.panic.excludes)
if [[ -z $g2excludes ]]; then
    read -p "Files to keep untouched (ie. \"-e .classpath -e .settings -e *.iml\"):" -e g2excludes
else
    read -p "Files to keep untouched ($g2excludes): " -e g2excludes
fi

[[ -n $nameinput ]] && "$GIT_EXE" config --global user.name "$nameinput"
[[ -n "$emailinput" ]] && "$GIT_EXE" config --global user.email "$emailinput"
[[ -n "$editor" ]] && "$GIT_EXE" config --global core.editor "$editor"
[[ -z $g2count ]] && g2count=true
"$GIT_EXE" config --global g2.prompt.countfiles $g2count
[[ -n $g2excludes ]] && "$GIT_EXE" config --global g2.panic.excludes "$g2excludes"

## MERGETOOL
mt_alias=$("$GIT_EXE" config merge.tool)
mergetools="araxis bc3 diffuse ecmerge emerge gvimdiff kdiff3 meld opendiff p4merge kdiff tortoisemerge vimdiff xxdiff CUSTOM"

PS3="What is the favorite merge tool ($mt_alias) ? "

select choice in $mergetools; do
if [[ -n $choice ]]; then
    if [[ $choice = "CUSTOM" ]]; then
        if [[ -z $mt_alias ]]; then
            read -p "Please input the mergetool alias: " -e mt_alias
        else
            read -p "Please input the mergetool alias ($mt_alias): " -e mt_alias
        fi
        [[ -z $mt_alias ]] && echo "The merge tool cannot be left blank, please make a selection..." && continue
        "$GIT_EXE" config --global merge.tool "$mt_alias"


        cmdLine=$("$GIT_EXE" config mergetool.${mt_alias}.cmd)
        if [[ -z $cmdLine ]]; then
            read -p "Please provide the command to call : " -e cmdLine
        else
            read -p "Command to call ($cmdLine): " -e cmdLine
        fi
        if [[ -z $cmdLine ]]; then
            "$GIT_EXE" config --global --unset mergetool.${mt_alias}.cmd
        else
            "$GIT_EXE" config --global mergetool.${mt_alias}.cmd "$cmdLine"
        fi
    else
        mt_alias=$choice
        echo "Merge tool set to $mt_alias, please make sure to include the application(s) in the PATH"
        "$GIT_EXE" config --global merge.tool "${mt_alias}"
        "$GIT_EXE" config --global --unset mergetool.${mt_alias}.cmd
    fi
    break

else
    echo "Invalid entry, please try again.\n"
fi
done

existCode=$("$GIT_EXE" config mergetool.${mt_alias}.trustExitCode)
if [[ -z $existCode ]]; then
    read -p "Trust $mt_alias exit code? (false) " -e existCode
else
    read -p "Trust $mt_alias exit code? ($existCode): " -e existCode
fi
[[ -z $existCode ]] && exitCode=false
"$GIT_EXE" config --global mergetool.${mt_alias}.trustExitCode $existCode



## DIFFTOOL

dt_alias=$("$GIT_EXE" config diff.tool)
difftools="araxis bc3 diffuse emerge ecmerge gvimdiff kdiff3 kompare meld opendiff p4merge tkdiff vimdiff xxdiff CUSTOM"


PS3="What is the favorite diff tool ($dt_alias) ? "

select choice in $difftools; do
if [[ -n $choice ]]; then
    if [[ $choice = "CUSTOM" ]]; then
        if [[ -z $dt_alias ]]; then
            read -p "Please input the difftool alias: " -e dt_alias;
        else
            read -p "Please input the difftool alias ($dt_alias): " -e dt_alias;
        fi
        [[ -z $dt_alias ]] && echo "The difftool cannot be left blank, please make a selection..." && continue;
        "$GIT_EXE" config --global diff.tool "$dt_alias"


        cmdLine=$("$GIT_EXE" config difftool.${dt_alias}.cmd)
        if [[ -z $cmdLine ]]; then
            read -p "Please provide the command to call : " -e cmdLine;
        else
            read -p "Command to call ($cmdLine): " -e cmdLine;
        fi
        if [[ -z $cmdLine ]]; then
            "$GIT_EXE" config --global --unset difftool.${dt_alias}.cmd
        else
            "$GIT_EXE" config --global difftool.${dt_alias}.cmd "$cmdLine"
        fi
    else
        dt_alias=$choice
        echo "Merge tool set to $dt_alias, please make sure to include the application(s) in the PATH"
        "$GIT_EXE" config --global diff.tool "${dt_alias}"
        "$GIT_EXE" config --global --unset difftool.${dt_alias}.cmd
    fi
    break

else
    echo "Invalid entry, please try again.\n"
fi
done

## SSH KEY
"$GIT_EXE" key -gen
