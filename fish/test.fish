#### PARSE STATUS
set -l untracked 0
set -l added 0
set -l modified 0

#set IFS '\n'
set -l git_status (command git status --porcelain ^/dev/null)

for line in $git_status
    set -l x (echo $line | cut -c 1)
    set -l y (echo $line | cut -c 2)

    if test $x = '?'
        set untracked (math $untracked + 1)
    else
        test $x != ' '; and  set added (math $added + 1)
        test $y != ' '; and  set modified (math $modified + 1)
    end
end

echo $untracked $added $modified



function __g2_getBranchOp

    set -l git_dir (command git rev-parse --git-dir 2>/dev/null)
    test ! -d $git_dir; and return 1

    ### Returns the branch name


    # endgures the state of the repo
    set -l op ''
    set -l branch ''

    command git ls-tree -quiet HEAD 2>/dev/null

    if test $status -eq 128 
        set op 'init'
    else

        set -l step 0
        set -l total 0

        if test -d "$git_dir/rebase-merge"

            set step (cat "$git_dir/rebase-merge/msgnum")
            set total (cat "$git_dir/rebase-merge/end")
            set branch (cat "$git_dir/rebase-merge/head-name")" $step/$total"

            if test -f "$git_dir/rebase-merge/interactive"
                set op "rebase -i"
            else
                set op "rebase -m"
            end

        else

            if test -d "$git_dir/rebase-apply"
                
                set step (cat "$git_dir/rebase-apply/next")
                set total (cat "$git_dir/rebase-apply/last")

                if test -f "$git_dir/rebase-apply/rebasing"
                    set op "rebase"
                else
                    if test -f "$git_dir/rebase-apply/applying"
                        set op "am"
                    else
                        set op "am/rebase"
                    end
                end
            else
                if test -f "$git_dir/MERGE_HEAD"
                    set op "merge"
                else
                    if test -f "$git_dir/CHERRY_PICK_HEAD"
                        set op "cherrypick"
                    else
                        if test -f "$git_dir/REVERT_HEAD"
                            set op "revert"
                        else
                            if test -f "$git_dir/BISECT_LOG"
                                set op "bisect"
                            end
                        end
                    end
                end
            end


            if not set branch (command git symbolic-ref HEAD 2>/dev/null)

                test ! "$op"; and set op "detached"

                if not set branch (command git describe --tags --exact-match HEAD 2>/dev/null)
                    if not set branch (cut -c 1-7 "$git_dir/HEAD" 2>/dev/null)'...'
                        set branch "unknown"
                    end
                end

                if test -n "$step" -a -n "$total" 
                    set branch "[$branch $step/$total]"
                else
                    set branch "[$branch]"
                end

            end
        end

    end

    echo $op
    echo $branch | sed  's/refs\/heads\///g'
end

set v (__g2_getBranchOp)
echo branch:$v[1]
echo op:$v[2]


####  GET GIT HEX-REVISION
set -l rawhex (command git rev-parse --short HEAD)
echo $rawhex


### AHEAD BEHIND
function __g2_prompt_aheadbehind --argument-names local

    set -l remote (__g2_getremote)

    set -l cnt (command git rev-list --left-right --count $local...$remote -- ^/dev/null |tr \t \n)
    if test $cnt[1] -gt 0 -a $cnt[2] -gt 0
        echo -n '±'
    else
        test $cnt[1] -gt 0; and echo -n '+'
        test $cnt[2] -gt 0; and echo -n '-'
    end
end

__g2_prompt_aheadbehind master
echo
