# name: g2 prompt
#
# Inspired from bobthefish is a Powerline-style, Git-aware fish theme optimized for awesome.
#
# You will probably need a Powerline-patched font for this to work:
#
#     https://powerline.readthedocs.org/en/latest/fontpatching.html
#
# I recommend picking one of these:
#
#     https://github.com/Lokaltog/powerline-fonts
#
# You can override some default options in your config.fish:
#
#     set -g theme_display_user yes
#     set -g default_user your_normal_user

set -g current_bg NONE

# Powerline glyphs
set branch_glyph            \uE0A0
set ln_glyph                \uE0A1
set padlock_glyph           \uE0A2
set right_black_arrow_glyph \uE0B0
set right_arrow_glyph       \uE0B1
set left_black_arrow_glyph  \uE0B2
set left_arrow_glyph        \uE0B3

# Additional glyphs
set detached_glyph          \u27A6
set superuser_glyph         '# '
set bg_job_glyph            '% '

# Colors
set lt_green   addc10
set med_green  189303
set dk_green   0c4801

set lt_red     C99
set med_red    ce000f
set dk_red     600

set slate_blue 255e87

set lt_orange  f6b117
set dk_orange  3a2a03

set dk_grey    333
set med_grey   999
set lt_grey    ccc

# ===========================
# Helper methods
# ===========================

function __g2prompt_pretty_parent -d 'Print a parent directory, shortened to fit the prompt'
  echo -n (dirname $argv[1]) | sed -e 's|/private||' -e "s|^$HOME|~|" -e 's-/\(\.\{0,1\}[^/]\)\([^/]*\)-/\1-g' -e 's|/$||'
end

function __g2prompt_project_dir -d 'Print the current git project base directory'
  command git rev-parse --show-toplevel ^/dev/null
end

function __g2prompt_project_pwd -d 'Print the working directory relative to project root'
  set -l base_dir (__g2prompt_project_dir)
  echo "$PWD" | sed -e "s*$base_dir**g" -e 's*^/**'
end

function __g2prompt_aheadbehind --argument-names local
    if test "$local"
      set -l remote (__g2_getremote)

      set -l cnt (command git rev-list --left-right --count $local...$remote -- ^/dev/null |tr \t \n)    
      if [ $cnt[1] -gt 0 -a $cnt[2] -gt 0 ]
          echo -n ' ±'
      else
          test $cnt[1] -gt 0; and echo -n ' +'
          test $cnt[2] -gt 0; and echo -n ' -'
      end
    end
end

function __g2prompt_getBranchOp

    set -l git_dir (command git rev-parse --git-dir ^/dev/null)
    test ! -d $git_dir; and return 1

    # get repo status & branch name
    set -l op ''
    set -l branch ''

    command git ls-tree HEAD >/dev/null ^/dev/null

    if test $status -eq 128 
        set op 'init'
    else

        set -l step
        set -l total

        if test -d "$git_dir/rebase-merge"

            set step (cat "$git_dir/rebase-merge/msgnum")
            set total (cat "$git_dir/rebase-merge/end")
            set branch (cat "$git_dir/rebase-merge/head-name")" $step/$total"

            if test -f "$git_dir/rebase-merge/interactive"
                set op 'rebase -i'
            else
                set op 'rebase -m'
            end

        else

            if test -d "$git_dir/rebase-apply"
                
                set step (cat "$git_dir/rebase-apply/next")
                set total (cat "$git_dir/rebase-apply/last")

                if test -f "$git_dir/rebase-apply/rebasing"
                    set op 'rebase'
                else
                    if test -f "$git_dir/rebase-apply/applying"
                        set op 'am'
                    else
                        set op 'am/rebase'
                    end
                end
            else
                if test -f "$git_dir/MERGE_HEAD"
                    set op 'merge'
                else
                    if test -f "$git_dir/CHERRY_PICK_HEAD"
                        set op 'cherrypick'
                    else
                        if test -f "$git_dir/REVERT_HEAD"
                            set op 'revert'
                        else
                            if test -f "$git_dir/BISECT_LOG"
                                set op 'bisect'
                            end
                        end
                    end
                end
            end


            if not set branch (command git symbolic-ref HEAD ^/dev/null)

                test ! "$op"; and set op 'detached'

                if not set branch (command git describe --tags --exact-match HEAD ^/dev/null)
                    if not set branch (cut -c 1-7 "$git_dir/HEAD" ^/dev/null)
                        set branch 'unknown'
                    end
                end

                if test "$step" -a "$total" 
                    set branch "[$branch $step/$total]"
                else
                    set branch "[$branch]"
                end

            end
        end

    end

    echo $branch >> /tmp/debug.log

    echo $branch | sed  's/refs\/heads\///g'
    echo $op
end


# ===========================
# Segment functions
# ===========================

function __g2prompt_start_segment -d 'Start a segment'
  set_color -b $argv[1]
  set_color $argv[2]
  if [ "$current_bg" = 'NONE' ]
    # If there's no background, just start one
    echo -n ' '
  else
    # If there's already a background...
    if [ "$argv[1]" = "$current_bg" ]
      # and it's the same color, draw a separator
      echo -n "$right_arrow_glyph "
    else
      # otherwise, draw the end of the previous segment and the start of the next
      set_color $current_bg
      echo -n "$right_black_arrow_glyph "
      set_color $argv[2]
    end
  end
  set current_bg $argv[1]
end

function __g2prompt_path_segment -d 'Display a shortened form of a directory'
  if test -w "$argv[1]"
    __g2prompt_start_segment $dk_grey $med_grey
  else
    __g2prompt_start_segment $dk_red $lt_red
  end

  set -l directory
  set -l parent

  switch "$argv[1]"
    case /
      set directory '/'
    case "$HOME"
      set directory '~'
    case '*'
      set parent    (__g2prompt_pretty_parent "$argv[1]")
      set parent    "$parent/"
      set directory (basename "$argv[1]")
  end

  test "$parent"; and echo -n -s "$parent"
  set_color fff --bold
  echo -n "$directory "
  set_color normal
end

function __g2prompt_finish_segments -d 'Close open segments'
  if [ -n $current_bg -a $current_bg != 'NONE' ]
    set_color -b normal
    set_color $current_bg
    echo -n "$right_black_arrow_glyph "
    set_color normal
  end
  set -g current_bg NONE
end


# ===========================
# Theme components
# ===========================

function __g2prompt_prompt_status -d 'the symbols for a non zero exit status, root and background jobs'
  set -l nonzero
  set -l superuser
  set -l bg_jobs

  # Last exit was nonzero
  test $RETVAL -ne 0; and set nonzero $RETVAL

  # if superuser (uid == 0)
  set -l uid (id -u $USER)
  test $uid -eq 0; and set superuser $superuser_glyph

  # Jobs display
  [ (jobs -l | wc -l) -gt 0 ]; and set bg_jobs $bg_job_glyph

  set -l status_flags "$nonzero$superuser$bg_jobs"

  if test "$nonzero" -o "$superuser" -o "$bg_jobs"
    __g2prompt_start_segment fff 000
    if [ "$nonzero" ]
      set_color $med_red --bold
      echo -n $nonzero_exit_glyph
    end

    if [ "$superuser" ]
      set_color $med_green --bold
      echo -n $superuser_glyph
    end

    if [ "$bg_jobs" ]
      set_color $slate_blue --bold
      echo -n $bg_job_glyph
    end
  end
end

function __g2prompt_prompt_user -d 'Display actual user if different from $default_user'
  if [ "$theme_display_user" = 'yes' ]
    if [ "$USER" != "$default_user" -o -n "$SSH_CLIENT" ]
      __g2prompt_start_segment $lt_grey $slate_blue
      echo -n -s (whoami) '@' (hostname | cut -d . -f 1) ' '
    end
  end
end

function __g2prompt_prompt_git -d 'Display the actual git state'

  set -l v (__g2prompt_getBranchOp)
  set -l branch $v[1]
  set -l op $v[2]

  set -l icon "$branch_glyph "
  test $op = 'detached'; and set icon "$detached_glyph "

  #### PARSE STATUS
  set -l new 0
  set -l staged 0
  set -l dirty 0

  set -l git_status (command git status --porcelain ^/dev/null)

  for line in $git_status
      set -l x (echo $line | cut -c 1)
      set -l y (echo $line | cut -c 2)

      if test $x = '?'
          set new (math $new + 1)
      else
          test $x != ' '; and  set staged (math $staged + 1)
          test $y != ' '; and  set dirty (math $dirty + 1)
      end
  end

  set -l flags (__g2prompt_aheadbehind $branch)

  set -l flag_bg $med_grey
  set -l flag_fg 000

  if test -n "$op"
    if test "$op" = 'init'
      set flag_bg fff
      set flag_fg 000
      set branch 'init'
    else
      set flag_bg $med_red
      set flag_fg fff
      set branch "$op:$branch"
    end
  else
      if test $staged -gt 0
        set flag_bg $lt_green
        set flag_fg $dk_green
      end

      if test $dirty -gt 0 -o $new -gt 0
          set flag_bg $lt_orange
          set flag_fg $dk_orange
      end
  end

  __g2prompt_path_segment (__g2prompt_project_dir)

  __g2prompt_start_segment $flag_bg $flag_fg
  set_color $flag_fg --bold
  echo -n -s $icon$branch $flags ' '

  set_color normal

  set -l project_pwd  (__g2prompt_project_pwd)
  if test "$project_pwd"
    if test -w "$PWD"
      __g2prompt_start_segment 333 999
    else
      __g2prompt_start_segment $med_red $lt_red
    end

    echo -n -s $project_pwd ' '
  end
end

function __g2prompt_prompt_dir -d 'Display a shortened form of the current directory'
  __g2prompt_path_segment "$PWD"
end


# ===========================
# Apply theme
# ===========================

function fish_prompt
  set -g RETVAL $status
  __g2prompt_prompt_status
  __g2prompt_prompt_user

  # don't use fish redirection here
  command git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
  if test $status -eq 0
    __g2prompt_prompt_git
  else
    __g2prompt_prompt_dir
  end

  __g2prompt_finish_segments
end

function fish_right_prompt
    set_color $fish_color_autosuggestion[1]
    printf (date "+$c2%H$c0:$c2%M$c0:$c2%S")

    set -l now (date +%s)
    if test $last_exec_timestamp
        set -l taken (math $now - $last_exec_timestamp)
        if test $taken -gt 10
            echo -n ', taken:'
            set_color $lt_orange
            echo -n $taken's'
            set_color $fish_color_autosuggestion[1]
        end
    end
    set -g last_exec_timestamp $now

    # Show loadavg when too high
    set -l load1m (uptime | grep -o '[0-9]\+\.[0-9]\+' | head -n1)
    set -l ncpu 1
    # osx
    if not set ncpu (sysctl hw.ncpu | cut -f2 -d' ')
      #linux
        if not set ncpu (grep -c ^processor /proc/cpuinfo)
            set ncpu 1
        end
    end
    set -l load1m_test (math $load1m \* 100 / $ncpu)
    if test $load1m_test -gt 100
      echo -n ', load:'
      set_color $lt_orange
      echo -n $load1m
      set_color $fish_color_autosuggestion[1]
    end

    # Show disk usage when low
    set -l du (df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 5 | cut -d'%' -f1)
    if test $du -gt 80
      echo -n ', du:'
      set_color $lt_orange
      echo -n $du
      set_color $fish_color_autosuggestion[1]
    end

    set_color normal
end
