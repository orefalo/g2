#
# G2 for fish shell
#
# Author - Olivier Refalo
#

#### output functions ------------------------------------------------------------------

function __g2_fatal
    set_color red;
    echo 'fatal: '$argv[1];
    set_color normal;
end

function __g2_info
    set_color --bold white;
    echo $argv[1];
    set_color normal;
end


#### IO functions ------------------------------------------------------------------

function __g2_askInput --argument-names prompt default trimResult

    function __g2_askprompt --no-scope-shadowing
        set_color --bold white;
        echo -n $prompt
        set_color normal
        if test "$default"
            set_color green
            echo -n ' ('$default')'
            set_color normal
        end
        echo -n ': '
    end

    set -l REPLY
    while test ! (echo "$REPLY" | tr -d ' ')
        read -p __g2_askprompt REPLY
        if test -z "$REPLY" -a -n "$default"
            set REPLY $default
        end
    end

    if test "$trimResult" = "true"
        echo "$REPLY" | tr -d ' '
    else
        echo $REPLY
    end

end

function __g2_askChoice --argument-names prompt choices default trimResult

    set -l list (echo $choices | tr ' ' \n)

    function __g2_askprompt --no-scope-shadowing
        set_color --bold white;
        echo $prompt:
        set_color normal

        set -l defaultFound 0
        for opt in $list
            if test "$opt" = "$default"
                set_color green
                echo '*' $opt
                set_color normal
                set defaultFound 1
            else
                echo $opt
            end
        end

        if test $defaultFound -eq 0 -a -n "$default"
                set_color green
                echo '*' $default
                set_color normal
        end

        set_color --bold white
        if test "$default"
            echo -n ' Choice ('$default'): '
        else
            echo -n ' Choice : '
        end
        set_color normal

    end

    set -l REPLY
    while test -z (echo "$REPLY" | tr -d ' ')
        read -p __g2_askprompt REPLY
        if test -z "$REPLY" -a -n "$default"
            set REPLY $default
        end
    end

    if test "$trimResult" = "true"
        echo "$REPLY" | tr -d ' '
    else
        echo "$REPLY"
    end

end


# 1 - means YES 0-No
function __g2_askYN --argument-names prompt

    function __g2_askprompt --no-scope-shadowing
        set_color --bold white;
        echo -n $prompt
        set_color green
        echo -n ' [y/N]'
        set_color normal
        echo -n '? > '
    end

    set -l REPLY
    while test -z "$REPLY"
        read -p __g2_askprompt -l REPLY
        switch $REPLY
            case y Y yes Yes YES
                return 1
        end
    end
    return 0
end

#### GIT Utility functions  ------------------------------------------------------------------

function __g2_getremote
    set -l remote (command git rev-parse --symbolic-full-name --abbrev-ref '@{u}' ^/dev/null)
    if test "$remote" = '@{u}'
        echo ''
    else
        echo $remote
    end
end

# Internal command that return "rebase", "merge" or "false" depending on the repository status
# returns true(0) if merge or rebase
function __g2_wrkspcState

    set -l git_dir (command git rev-parse --git-dir ^/dev/null)

    if test -d "$git_dir/rebase-merge" -o -d "$git_dir/rebase-apply"
        echo 'rebase'
        return 0
    end

    if test -d "$git_dir/MERGE_HEAD"
        echo 'merge'
        return 0
    end

    echo 'false'
    return 1
end

# Returns true(1) if the branch is behind its matching upstream branch
function __g2_isbehind  --argument-names remote

    set -l branch (command git rev-parse --symbolic-full-name --abbrev-ref HEAD)
    if test -z "$remote"
        set remote (__g2_getremote)
    end
    if test "$remote"
        command git fetch
        set -l CNT (command git rev-list --right-only --count $branch...$remote -- )
        if test $CNT -gt 0
            return 1;
        end
    end
    return 0
end

# Returns true(1) if the branch is forward its matching upstream branch
function __g2_isforward  --argument-names remote

    set -l branch (command git rev-parse --symbolic-full-name --abbrev-ref HEAD)
    test ! "$remote";and set remote (__g2_getremote)
    if test "$remote"
        set -l CNT (command git rev-list --left-only --count $branch...$remote -- )
        if test $CNT -gt 0
            return 1
        end
    end
    return 0
end

# Returns true(1) if the given branch was force updated
#   if no parameters are provided, figures the upstream branch from the tracking table
function __g2_isforced --argument-names remote

    test ! "$remote";and set remote (__g2_getremote)
    if test "$remote"
        command git rev-list $remote | grep -quiet (command git rev-parse $remote ) ^/dev/null; and return 1
    end
    return 0
end

# Returns true(1) if the repo has pending changes
function __g2_isdirty

#    if command git diff --no-ext-diff --quiet --exit-code
#        command git diff --cached --no-ext-diff --quiet --exit-code; and return 0
#    end

    if command git diff-files --quiet
        command git diff-index --quiet --cached HEAD; and return 0
    end

    __g2_fatal 'Changes detected, please commit them or get them out of the way <g wip>. You may also discard them with a <g panic>.'
    return 1

end

# return true(1) if top commit is wip - work in progress
# the proper validation is __g2_iswip; or return 1
function __g2_iswip --argument-names remote

    #command git rev-parse; or return 0

    test ! "$remote";and set remote (__g2_getremote)

    set -l wip 0
    if test -z "$remote"
        set wip (command git log --online -1 ^/dev/null | cut -f 2 -d ' ' | grep -c wip)
    else
        set wip (command git log $remote..HEAD --oneline ^/dev/null | cut -f 2 -d ' ' | uniq | grep -c wip)
    end

    if test $wip -gt 0
        __g2_fatal 'Work In Progress (wip) detected, please run <g unwip> to resume work items first.'
        return 1;
    end

    return 0;
end


#### Now the real thing ------------------------------------------------------------------


function __g2_usage
	echo "G2 Usage:
	abort - aborts any rebase/merge
	am <?-f> - amends last commit with staging area
	br <?-D> <?-M> <?branch> - list or create branches
	bs - bisect, aka bug finder
	co <branch> - switches branch (either local/remote)
	continue - resumes a conflict resolution
	cp <commit> - cherry-pick
	ci <?params...> - commit
	clone <url> - clone a remote repository
	df/dt <?params...> <file> - compares files
	fetch - gets changes sitting on the server
	freeze/unfreeze <?-m comment> <?file> - freeze/unfreeze files
	gc - garbage collects repository, runs fsck & gc
	gp - grep
	gui - launches the GUI
	ig <file> - adds to gitignore & removes from source control
	init <folder> - init a repository
	key <?-gen> - displays/generates your ssh public key
	mg <?params...> <branch> - merge
	mt <?params...> - fixes conflicts by opening a visual mergetool
	mv - move (rename) a file
	lg - displays branch history log
	ls <?params...> - list files under source control
	panic - gets you back on HEAD, cleans all untracked files
	pull/push <?opts> <remote> <branch> - deals with other branches
	rb <?params...> <branch> or <upstream> - rebase
	rm <params...> - remove files
	rs <params...> - reset branch status
	rs upstream - resets branch to upstream state
	rt <?params...> - git remotes management
	rv <commit> - reverts commits
	server - starts a local git:// server on current repo
	setup - configures user, key, editor, tools
	sh <?-deep> - show commit contents
	sm <?params...> - submodule management
	ss <?params> - stash changes
	st <?params...> - display status
	sync <?upstream> - syncs working branch: fetch, rebase & push
	tg - tag
	track <?upstream_branch> - shows/set remove branch tracking
	undo <file>|commit|merge - reverts last changes
	version - prints g2 version
	wip/unwip - save/restore work in progress to branch"
end

function __g2_lg
    if test (count $argv) -eq 0
        command git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
    else
        command git log $argv
    end
end

function __g2_st
    if test (count $argv) -eq 0
        command git status
    else
        command git status $argv
    end
end

function __g2_freeze --argument-names flag msg
    command git rev-parse; or return 1

    if test "$flag" = '-m'
        if test "$msg"
            # remove two parameters from the left
            if test (count $argv) -gt 2
                set argv $argv[3..-1]
            else
                set argv
            end
        else
            __g2_fatal 'Usage: freeze -m message'
        end
    end
    begin
        if test -z "$argv"
            command git add -A :/
        else
            command git add -A $argv
        end
    end;
    and if test "$msg"
          __g2_ci -m "$msg"; and command git status -s
    end
    return 0
end

function __g2_unfreeze
    command command git rev-parse; or return 1
    if test -z "$argv"
        if test (command git reset -q HEAD > /dev/null) -eq 1
            __g2_fatal 'The first repo commit must be unfrozen file by file. Sorry about that...'
            return 1
        end
    else
        command git reset -q HEAD -- $argv > /dev/null; or command git rm -q --cached $argv
    end
    command git status
end

function __g2_ci
    __g2_iswip; or return 1

    if command git diff --cached --no-ext-diff --quiet --exit-code
         __g2_fatal 'No changes to amend, please use <g freeze> to stage your modification, then try amending again.'
       return 1
    else
        command git commit $argv
        return $status
    end
end

function __g2_am
    command git rev-parse; or return 1

    if command git diff --cached --no-ext-diff --quiet --exit-code
         __g2_fatal 'No changes to amend, please use <g freeze> to stage your modification, then try amending again.'
       return 1
    end
    
    if __g2_isforward
        if test "$argv[1]" = '-f'
            __g2_askYN 'Warning: force amending will rewrite the history, please confirm'; and return 1
        else
            __g2_fatal 'There are no local commits to amend.'
            return 1
        end
    end
    command git commit --amend -C HEAD
end

function __g2_cp
    command git rev-parse; or return 1
     __g2_iswip; or return 1
    command git cherry-pick $argv
end

function __g2_ig
    command git rev-parse; or return 1

    if test -z "$argv"
        __g2_info 'Usage: ignore [file]'
    else
        if test not -e .gitignore
            touch .gitignore
        end

        echo "$GIT_PREFIX$argv[1]" >> .gitignore
        __g2_info "Ignoring file $argv[1]"
        command git rm --cached $GIT_PREFIX$argv >/dev/null ^&1
        command git status
    end
end

function __g2_server
    command git config --global alias.server "daemon --verbose --export-all --base-path=.git --reuseaddr --strict-paths .git/"
end

function __g2_abort
    command git rev-parse; or return 1
    command git merge --abort ^ /dev/null; or command git rebase --abort ^ /dev/null
end

function __g2_continue

    command git rev-parse; or return 1

    switch (__g2_wrkspcState)

        case rebase
            set action '--continue'
            command git diff-index --quiet HEAD --
            if test $status -eq 0
                __g2_info "The last commit brings no significant changes -- automatically skipping"
                set action '--skip'
            end
            command git rebase $action ^ /dev/null
            return 0

        case merge
            # Count the number of unmerged files
            set count=(command git ls-files --unmerged | wc -l)
            if [ $count -ne 0 ]
               __g2_fatal ">>>>> Hey! you still have unmerged files, please run <g mt> to resolve conflicts"
               return 1
            else
               command git commit
               return $status
            end
    end
end

function __g2_panic
    command git rev-parse; or return 1

    __g2_askYN 'This action may discard all uncommited changes, are you sure'
    if test $status -eq 1
        __g2_abort
        set -l g2excludes (command git config --global --get g2.panic.excludes)
        command git reset --hard HEAD; and command git clean -fdx $g2excludes
        set -l branch (command git rev-parse --symbolic-full-name --abbrev-ref HEAD)
        if [ "$branch" = '(no branch)' ]
            command git checkout master
        end
    end
end

function __g2_gc
    command git rev-parse; or return 1

    command git fetch --all -p
    and command git fsck
    and command git reflog expire --expire=now --all
    and command git gc --aggressive --prune=now
end

function __g2_br
   command git rev-parse; or return 1

    if test (count $argv) -eq 0
        command git branch -a
        echo '-----------------'

        command git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads |  \
        while read local remote
            test ! "$remote"; and continue

            set -l count (command git rev-list --left-right --count $local...$remote -- ^/dev/null |tr \t \n); or continue
            __g2_info "$local (to sync:$count[1]) | (to merge:$count[2]) $remote"
        end
    else
        command git branch $argv
    end
end

# displays or generates ssh keys
function __g2_key --argument-names opt

    if test "$opt" = "-gen"
        if test -f $HOME/.ssh/id_rsa.pub
            __g2_askYN 'Regenerate SSH Key'; and return 1
        end

         __g2_info 'Generating SSH keys...'
         set -l emailinput (command git config --global --get user.email)
         command ssh-keygen -t rsa -P '' -C "$emailinput" -f "$HOME/.ssh/id_rsa"
    end

    if test -f "$HOME/.ssh/id_rsa.pub"
        set_color yellow
        cat "$HOME/.ssh/id_rsa.pub"
        set_color normal
    else
        __g2_fatal "SSH key not found at $HOME/.ssh/id_rsa.pub"
        return 1
    end
end

function __g2_wip
    command git rev-parse; or return 1

    __g2_iswip
    if test $status -eq 1
        __g2_info "Amending previous wip commit..."
        __g2_freeze; and command git commit --amend -C HEAD
    else
        __g2_freeze -m "wip"
    end
end

function __g2_unwip
    command git rev-parse; or return 1

    __g2_iswip
    if test $status -eq 0
        __g2_fatal "There is nothing to unwip..."
    else
        if test -z (command git log -n 1 | grep -q -c "wip")
            command git reset HEAD~1
        end
    end
end

function __g2_track --argument-names branch

    command git rev-parse; or return 1
    if test "$branch"

        if test (echo $branch | grep -e '^[()a-zA-Z0-9\._\-]*/[()a-zA-Z0-9\._\-]*$' | wc -l) -ne 1
            __g2_fatal "The remote branch mush be specified in the form remote/branchname."
            return 1
        end

        command git ls-remote --exit-code . "$branch"  >/dev/null ^&1
        if test $status -ne 0

            if not __g2_askYN "Remote branch not found, would you like to refresh from the server"
                command git fetch
                __g2_info "Good, now try the command again";
                return 1
            end
        end
        command git branch --set-upstream-to "$branch"
    else
        __g2_info "--Tracking--------------"
        set_color green
        command git for-each-ref --format='local: %(refname:short) <--sync--> remote: %(upstream:short)' refs/heads
        __g2_info "--Remotes---------------"
        set_color yellow
        command git remote -v
        set_color normal
    end
end

function __g2_version
    __g2_info 'G2 is based on '(command git version)" and fish version $FISH_VERSION"
end

function __g2_rs --argument-names arg1

    command git rev-parse; or return 1

    if test "$arg1" = 'upstream'     
        if not __g2_askYN 'Warning: resetting to the upstream may erase local changes, are you sure'
            __g2_abort
            set -l remote (__g2_getremote)
            if test "$remote"
                __g2_info "Resetting branch to $remote"
                command git reset --hard "$remote"
            else
                __g2_fatal 'Please setup tracking for this branch, for instance <g track remote/branch>'
            end
        end
    else
        command git reset $argv
    end
end

function __g2_rb

    command git rev-parse; or return 1

    if test (__g2_wrkspcState) = 'false'
        if __g2_askYN 'The branch history is about to be rewritten. It is an advanced operation, please confirm'
            return 1
        end
    end

    command git rebase $argv
end

function __g2_mg

    command git rev-parse; or return 1

    if test (__g2_isbehind) -eq 1
        __g2_askYN 'It appears the current branch is in the past, proceed with the merge'; and return 1
    end

    # merge returns 0 when it merges correctly
    command git merge $argv
    if test $status -ne 0
        set -l unmerged (command git ls-files --unmerged)
        if test "$unmerged"
            __g2_info 'A few files need to be merged manually, please use <g mt> to fix conflicts...'
            __g2_info ' once all resolved, <freeze> and <commit> the files.'
            __g2_info ' note: you may abort the merge at any time with <g abort>.'
        end
        return 1;
    end
end

function __g2_co --argument-names branch
    command git rev-parse; or return 1

    # check if it's a hash
    if test -z (echo "$branch" | grep -e '^[()a-zA-Z0-9\._\-]*$')

        if test (command git branch -a | grep -c "$branch") -gt 0
            __g2_abort
            __g2_isdirty; or return 1
            set -l g2excludes (command git config --global --get g2.panic.excludes)
            command git checkout $argv; and command git clean -fdx $g2excludes
            return $status
        end

        __g2_info "There is no branch named '$branch', you may want to run <g fetch> to refresh from the server"
        __g2_info "If you are trying to revert a file, consider <g undo $branch>"

    else
        command git checkout $argv
    end
    return $status
end

function __g2_add

    command git rev-parse; or return 1
    __g2_iswip; or return 1

    set -l level (command git config --global --get g2.userlevel)
    if test "$level" = 'advanced'
        command git add $argv
    else
        __g2_fatal "Please don't use <add> with G2, <freeze> and <unfreeze> are powerful commands"
    end

end

function __g2_undo --argument-names action

    command git rev-parse; or return 1
    if test (count $argv) -lt 1
        __g2_fatal 'Usage : g undo <file|commit|merge> <?path>'
        return 1
    end

    __g2_askYN 'Warning: the action may discard your changes, would you like to continue'; and return 1

    switch $action
        case commit
            __g2_isforward
            __g2_askYN 'It appears you already synced the changes to the server. Are you sure you want to alter the branch history'; and return 1
            __g2_info 'Undoing last commit and moving changes to the staging area.'
            command git reset --soft HEAD^

        case merge
            __g2_isforward
            __g2_askYN 'It appears you already synced the changes to the server. Are you sure you want to alter the branch history'; and return 1
            __g2_info 'Reverting back prior to the last merge.'
            command git reset --hard ORIG_HEAD

        case '*'        
            command git checkout -- $argv[1]
    end
end

function __g2_push

    command git rev-parse; or return 1
    __g2_iswip; or return 1

    # figure if the force flag is being used
    set -l forceFlag 0
    set -l idx 1
    for v in $argv
        switch $v
            case '-f' '--force'
                set forceFlag 1
                set -e argv[$idx]
        end
        set idx (math $idx + 1)
    end

    set idx (count $argv)

    if test $idx -lt 2 -a $forceFlag -eq 0 
        __g2_info 'Remember, you may only use <push> or <pull> against a feature branch, and <sync> against the working branch.'
        __g2_fatal 'Usage: push <?opts> <remote> <branch>'
        return 1
    end

    # read the branch
    set -l branch $argv[$idx]
    set -e argv[$idx]
    set idx (math $idx - 1)

    # read remote
    set -l rmt $argv[$idx]
    set -e argv[$idx]

    set -l dst "$rmt/$branch"
    set -l remote (__g2_getremote)

    if test -z "$remote"
        __g2_askYN "Would you like to track $dst"; or __g2_track "$dst"
    else
        if test $forceFlag -eq 0 -a "$dst" = "$remote"

            set -l level (command git config --global --get g2.userlevel)
            if test "$level" = 'advanced'
                __g2_askYN "Advanced: Are you sure you want to PUSH?"; or command git pull --no-ff $argv $rmt $branch
            else
                __g2_fatal 'Please use <sync> to synchronize the current branch and <push> to copy to another branch'
                return 1
            end
        end
    end

    if test $forceFlag -eq 1
        command git push -f $argv $rmt $branch
    else
        command git push $argv $rmt $branch
    end
    return $status
end

# g2 pull uses the --no-ff flag
function __g2_pull

    command git rev-parse; or return 1
    __g2_iswip; or return 1

    set -l idx (count $argv)
    if test $idx -lt 2
        __g2_fatal 'Usage: pull <?opts> <remote> <branch>'
        return 1
    end

    # read the branch
    set -l branch $argv[$idx]
    set -e argv[$idx]
    set idx (math $idx - 1)

    # read remote
    set -l rmt $argv[$idx]
    set -e argv[$idx]
    set -l dst "$rmt/$branch"
    set -l remote (__g2_getremote)

    if test -z "$remote"
        __g2_askYN "Would you like to track $dst"; or __g2_track "$dst"
    else
        if test "$dst" = "$remote"
            set -l level (command git config --global --get g2.userlevel)
            if test "$level" = 'advanced'
                 __g2_askYN "Advanced: Are you sure you want to PULL?"; or command git pull --no-ff $argv $rmt $branch
            else
                __g2_fatal 'Please use <sync> to synchronize the current branch and <pull> to merge a feature branch'
                return 1
            end
         end
    end

    command git pull --no-ff $argv $rmt $branch
    return $status
end

# Performs a fetch, rebase, push with a bunch of validations
function __g2_sync --argument-names flag

    command git rev-parse; or return 1
    __g2_iswip; or return 1
    __g2_isdirty; or return 1

    set -l pullOnly 0
    if test "$flag" = "--pull-only"
        set pullOnly 1
        set -e argv[1]
    end

    if test (count $argv) -gt 0
        __g2_info 'Remember, you may only use <sync> against the working branch, use <pull> or <push> for feature branches.'
        __g2_fatal 'Usage: sync <?--pull-only>'
        return 1
    end

    set -l remote (__g2_getremote)
    if test -z "$remote"
            __g2_fatal 'Please use <g track remote/branch> to setup branch tracking'
            return 1
    end

    command git fetch; or return $status
    
    if not __g2_isforced $remote
        __g2_fatal 'It appears the history of the branch was changed on the server.'
        __g2_fatal 'please issue <g reset upstream> or <g rebase $remote> to resume'
        return 1
    end

    set -l branch (command git rev-parse --symbolic-full-name --abbrev-ref HEAD)

    # count the number of changes in/out
    #set -l tmpfile "/tmp/delta$RANDOM"

    set -l count (command git rev-list --left-right --count "$branch...$remote" -- ^/dev/null |tr \t \n)
    

    # command git rev-list --left-right "$branch...$remote" -- ^ /dev/null > "$tmpfile"
    set -l lchg $count[1]
    set -l rchg $count[2]

    echo "pullOnly:$pullOnly  rchg:$rchg  lchg:$lchg"
    if test $rchg -gt 0
        echo rebasing...
        if not command git rebase $remote
            set unmerged (command git ls-files --unmerged)
            if test "$unmerged"
                __g2_info "A few files need to be merged manually, please use <g mt> to fix conflicts."
                __g2_info " Once all conflicts are resolved, do NOT commit, but use <g continue> to resume."
                __g2_info " Note: you may abort the merge at any time with <g abort>."
                return 1;
            end
        end
    end

    echo "pullOnly:$pullOnly  rchg:$rchg  lchg:$lchg"
    if test $pullOnly -eq 0 -a $lchg -gt 0
        echo pushing...
        command git push
        return $status
    end
    return 0;
end

function __g2_mg

   command git rev-parse; or return 1
   __g2_iswip; or return 1

    if not __g2_isbehind
        __g2_askYN "It appears the current branch is in the past, proceed with the merge"; and return 1
    end

    # merge returns 0 when it merges correctly
    
    if command git merge $argv
        set -l unmerged (command git ls-files --unmerged)
        if test $unmerged
            __g2_info "A few files need to be merged manually, please use <g mt> to fix conflicts..."
            __g2_info " once all resolved, <g freeze> and <g commit> the files."
            __g2_info " note: you may abort the merge at any time with <g abort> ."
        end
        retrun 1
    end
end

function __g2_setup

    __g2_info "-----------------------------------------------------"
	__g2_info " G2 setup, press <ENTER> to select the default value"
    __g2_info "-----------------------------------------------------"

	## USER NAME
	set -l default (command git config --global --get user.name)
	set -l nameinput (__g2_askInput "Please input your full name" "$default" false)
    command git config --global user.name "$nameinput"
	
	## EMAIL
    __g2_info "-----------------------------------------------------"
	set -l default (command git config --global --get user.email)
	set -l emailinput (__g2_askInput "Please input your email" "$default" true)
    command git config --global user.email "$emailinput"

	## EDITOR
    __g2_info "-----------------------------------------------------"
	set -l default (command git config --global --get core.editor)
    test ! "$default"; and set default vi
	set -l editor (__g2_askInput "Preferred Editor" "$default" false)
    command git config --global core.editor "$editor"

	## EXCLUDE FILES
    __g2_info "-----------------------------------------------------"
	set -l default (command git config --global --get g2.panic.excludes)
    test ! "$default"; and set default "-e .classpath -e .settings -e *.iml"
	set -l g2excludes (__g2_askInput 'Pattern of files to keep untouched' "$default" false)
	command git config --global g2.panic.excludes "$g2excludes"

	## DIFFTOOL
    __g2_info "-----------------------------------------------------"
	set -l difftools "difftools araxis bc3 diffuse emerge ecmerge gvimdiff kdiff3 kompare meld opendiff p4merge tkdiff vimdiff xxdiff deltawalker"
	set -l default_dt (command git config diff.tool)
    set -l choice (__g2_askChoice 'Please select a difftool' "$difftools" "$default_dt" true)
	command git config --global diff.tool "$choice"

	## MERGETOOL	
    __g2_info "-----------------------------------------------------"
	set -l mergetools "difftools araxis bc3 diffuse emerge ecmerge gvimdiff kdiff3 kompare meld opendiff p4merge tkdiff vimdiff xxdiff deltawalker"
	set -l default_mt (command git config merge.tool)
    set -l choice (__g2_askChoice 'Please select a mergetool' "$mergetools" "$default_mt" true)
	command git config --global merge.tool "$choice"

	## TRUST EXIT CODE
    __g2_info "-----------------------------------------------------"
	set -l default (command git config mergetool.$choice.trustExitCode)
    test ! $default; and set default false
    set -l existCode (__g2_askInput "Trust mergetool exit code?" "$default" false)
    command git config --global mergetool.$choice.trustExitCode $existCode

    ## COLOR
    command git config --global color.branch auto
    command git config --global color.diff auto
    command git config --global color.interactive auto
    command git config --global color.status auto

    # FIX A FEW OTHER SETTINGS

    # For windows, use these default settings
    if test (uname -a | grep -c MINGW) -eq 1
        command git config --global core.autocrlf true
        command git config --global core.symlinks false
        command git config --global pack.packSizeLimit 2g
    else
        command git config --global core.autocrlf input
    end

    command git config --global core.safecrlf warn
    command git config --global push.default current
    command git config --global mergetool.keepBackup false

    __g2_info "-----------------------------------------------------"
    __g2_info "For the prompt to display correctly, remember to have"
    __g2_info " your terminal use a Powerline-patched font."
    __g2_info "Sample Powerline-p fonts can be downloaded from"
    __g2_info "          https://github.com/Lokaltog/powerline-fonts"
    __g2_info "-----------------------------------------------------"

	## SSH KEY
	__g2_key -gen

end

function g
    if test (count $argv) -eq 0
        __g2_usage;
    else
        set -l CMDS "abort"\
        "add"\
        "am"\
        "br"\
        "branch"\
        "bs"\
        "bisect"\
        "clone"\
        "ci"\
        "commit"\
        "co"\
        "checkout"\
        "continue"\
        "cp"\
        "cherry-pick"\
        "df"\
        "diff"\
        "dt"\
        "difftool"\
        "fetch"\
        "freeze"\
        "gc"\
        "gp"\
        "grep"\
        "gui"\
        "help"\
        "ig"\
        "init"\
        "key"\
        "lg"\
        "log"\
        "ls"\
        "ls-files"\
        "mg"\
        "merge"\
        "mt"\
        "mergetool"\
        "mv"\
        "panic"\
        "pull"\
        "push"\
        "rb"\
        "rebase"\
        "refresh"\
        "rt"\
        "remote"\
        "rm"\
        "rs"\
        "reset"\
        "rv"\
        "revert"\
        "setup"\
        "server"\
        "sh"\
        "show"\
        "sm"\
        "submodule"\
        "ss"\
        "stash"\
        "st"\
        "status"\
        "sync"\
        "tg"\
        "tag"\
        "track"\
        "undo"\
        "unfreeze"\
        "unwip"\
        "version"\
        "wip";

       set -l arg1 $argv[1]

        for i in $CMDS

            if test "$i" = "$arg1"

                # strip the first argument, if any
                set -e argv[1]

                # fish and eval doen't play well together, the following does work well with builtin functions
                # eval $CMDS[(math $i+1)] '$argv'

                switch $i
                    case abort
                        __g2_abort
                    case add
                        __g2_add
                    case am
                        __g2_am $argv
                    case br branch
                        __g2_br $argv
                    case bs bisect
                        command git bisect $argv
                    case clone
                        command git clone $argv
                    case ci commit
                        __g2_ci $argv
                    case co checkout
                        __g2_co $argv
                    case continue
                        __g2_continue
                    case cp cherry-pick
                        __g2_cp $argv
                    case df diff
                        command git diff $argv
                    case dt difftool
                        command git difftool $argv
                    case fetch
                        command git fetch $argv
                    case freeze
                        __g2_freeze $argv
                    case gc
                        __g2_gc
                    case gp grep
                        command git grep $argv
                    case gui
                        command git gui $argv
                    case help
                        command git help $argv
                    case ig
                        __g2_ig $argv
                    case init
                        command git init $argv
                    case key
                        __g2_key $argv
                    case lg log
                        __g2_lg $argv
                    case ls ls-files
                        command git ls-files $argv
                    case mg merge
                        __g2_mg $argv
                    case mt mergetool
                        command git mergetool $argv
                    case mv
                        command git mv $argv
                    case panic
                        __g2_panic
                    case pull
                        __g2_pull $argv
                    case push
                        __g2_push $argv
                    case rb rebase
                        __g2_rb $argv
                    case refresh
                        __g2_refresh
                    case rt remote
                        command git remote $argv
                    case rm
                        command git rm $argv
                    case rs reset
                        __g2_rs $argv
                    case rv revert
                        __g2_rv $argv
                    case setup
                        __g2_setup
                    case server
                        __g2_server
                    case sh show
                        command git show $argv
                    case sm submodule
                        command git submodule $argv
                    case ss stash
                        command git stash $argv
                    case st status
                        __g2_st $argv
                    case sync
                        __g2_sync $argv
                    case tg tag
                        command git tag $argv
                    case track
                        __g2_track $argv
                    case undo
                        __g2_undo $argv
                    case unfreeze
                        __g2_unfreeze $argv
                    case unwip
                        __g2_unwip
                    case version
                        __g2_version
                    case wip
                        __g2_wip
                    case '*'
                        __g2_fatal "Action $i not implemented"
                        return 1
                end
                return $status
            end
        end

        __g2_usage
        __g2_fatal "Invalid g2 command!"
        return 1

    end
end

set GIT_EXE (which git)
test ! "$GIT_EXE"; and __g2_fatal "Sorry, git is a required G2 dependency and must be in the PATH"
set -x GIT_EXE