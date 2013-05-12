#!/bin/bash

GIT_EXE=$(which git)
if [ -z "$GIT_EXE" ]; then
  echo "Sorry git not found in the PATH";
  return;
fi
export GIT_EXE;

# don't set prompt if this is not interactive shell
if [ -n "$BASH_VERSION" ]; then
    if [[ $- != *i* ]]; then
        return;
    fi
fi

###################################################################   CONFIG

#####  read config file if any.

unset dir_color rc_color user_id_color root_id_color init_vcs_color clean_vcs_color
unset modified_vcs_color added_vcs_color untracked_vcs_color op_vcs_color detached_vcs_color hex_vcs_color
unset rawhex_len

conf=g2-prompt.conf;
if [ -r $conf ]; then . $conf; fi
conf=/etc/profile.d/g2-prompt.conf;
if [ -r $conf ]; then . $conf; fi
conf=/etc/g2/g2-prompt.conf;
if [ -r $conf ]; then . $conf; fi
conf=/etc/g2-prompt.conf;
if [ -r $conf ]; then . $conf; fi
conf=~/.g2-prompt.conf;
if [ -r $conf ]; then . $conf; fi
unset conf


#####  set defaults if not set

cwd_cmd=${cwd_cmd:-cwd_truncate 40}

use_colors=${use_colors:-on}

#### dir, rc, root color
#    cols=`tput colors`                              # in emacs shell-mode tput colors returns -1
if [[ $use_colors = "on" ]];  then       #  if terminal supports colors
        dir_color=${dir_color:-CYAN}
        rc_color=${rc_color:-red}
        user_id_color=${user_id_color:-GREEN}
        root_id_color=${root_id_color:-magenta}
        host_color=${host_color:-green}
else                                            #  only B/W
        dir_color=${dir_color:-bw_bold}
        rc_color=${rc_color:-bw_bold}
fi
unset cols

#### prompt character, for root/non-root
if [ $(uname -s) = "Darwin" ]; then
    prompt_char=${prompt_char:-'➤'}
else
    prompt_char=${prompt_char:-'>'}
fi
root_prompt_char=${root_prompt_char:-'#'}

#### vcs colors
init_vcs_color=${init_vcs_color:-WHITE}            # initial
clean_vcs_color=${clean_vcs_color:-cyan}           # nothing to commit (working directory clean)
modified_vcs_color=${modified_vcs_color:-magenta}  # Changed but not updated:
added_vcs_color=${added_vcs_color:-green}          # Changes to be committed:
untracked_vcs_color=${untracked_vcs_color:-yellow} # Untracked files:
op_vcs_color=${op_vcs_color:-MAGENTA}
detached_vcs_color=${detached_vcs_color:-RED}
hex_vcs_color=${hex_vcs_color:-WHITE}              # gray

short_hostname=${short_hostname:-on}
upcase_hostname=${upcase_hostname:-on}
rawhex_len=${rawhex_len:-5}

#####################################################################  post config

        ################# terminfo colors-16
        #
        #       black?    0 8
        #       red       1 9
        #       green     2 10
        #       yellow    3 11
        #       blue      4 12
        #       magenta   5 13
        #       cyan      6 14
        #       white     7 15
        #
        #       terminfo setaf/setab - sets ansi foreground/background
        #       terminfo sgr0 - resets all attributes
        #       terminfo colors - number of colors
        #
        #################  Colors-256
        #  To use foreground and background colors:
        #       Set the foreground color to index N:    \033[38;5;${N}m
        #       Set the background color to index M:    \033[48;5;${M}m
        # To make vim aware of a present 256 color extension, you can either set
        # the $TERM environment variable to xterm-256color or use vim's -T option
        # to set the terminal. I'm using an alias in my bashrc to do this. At the
        # moment I only know of two color schemes which is made for multi-color
        # terminals like urxvt (88 colors) or xterm: inkpot and desert256,

        ### if term support colors,  then use color prompt, else bold

              black='\[\033[0;30m\]'
                red='\[\033[0;31m\]'
              green='\[\033[0;32m\]'
             yellow='\[\033[0;33m\]'
               blue='\[\033[0;34m\]'
            magenta='\[\033[0;35m\]'
               cyan='\[\033[0;36m\]'
              white='\[\033[0;37m\]'

                RED='\[\033[1;31m\]'
              GREEN='\[\033[1;32m\]'
             YELLOW='\[\033[1;33m\]'
               BLUE='\[\033[1;34m\]'
            MAGENTA='\[\033[1;35m\]'
               CYAN='\[\033[1;36m\]'
              WHITE='\[\033[1;37m\]'

	  goto_1col='\[\033[G\]'
       colors_reset='\[\e[0m\]'

        # replace symbolic colors names to raw treminfo strings
                 init_vcs_color=${!init_vcs_color}
             modified_vcs_color=${!modified_vcs_color}
            untracked_vcs_color=${!untracked_vcs_color}
                clean_vcs_color=${!clean_vcs_color}
                added_vcs_color=${!added_vcs_color}
                   op_vcs_color=${!op_vcs_color}
             addmoded_vcs_color=${!addmoded_vcs_color}
             detached_vcs_color=${!detached_vcs_color}
                  hex_vcs_color=${!hex_vcs_color}

        unset PROMPT_COMMAND

        #######  work around for MC bug.
        #######  specifically exclude emacs, want full when running inside emacs
        if   [[ -z "$TERM"   ||  ("$TERM" = "dumb" && -z "$INSIDE_EMACS")  ||  -n "$MC_SID" ]];   then
                unset PROMPT_COMMAND
                PS1="\w$prompt_char "
                return 0
        fi

        ####################################################################  MARKERS
        if [[ "$LC_CTYPE $LC_ALL" = *UTF* && $TERM != "linux" ]];  then
                elipses_marker="…"
        else
                elipses_marker="..."
        fi

        export who_where


cwd_truncate() {
        # based on:   https://www.blog.montgomerie.net/pwd-in-the-title-bar-or-a-regex-adventure-in-bash

        # arg1: max path lenght
        # returns abbrivated $PWD  in public "cwd" var

        cwd=${PWD/$HOME/\~}             # substitute  "~"

        case $1 in
                full)
                        return
                        ;;
                last)
                        cwd=${PWD##/*/}
                        [[ $PWD == $HOME ]]  &&  cwd="~"
                        return
                        ;;
                *)
                        # if bash < v3.2  then don't truncate
                        if [[  ${BASH_VERSINFO[0]} -eq 3   &&   ${BASH_VERSINFO[1]} -le 1  || ${BASH_VERSINFO[0]} -lt 3 ]] ;  then
                            return
                        fi
                        ;;
        esac

        # split path into:  head='~/',  truncateble middle,  last_dir

        local cwd_max_length=$1
        # expression which bash-3.1 or older can not understand, so we wrap it in eval
        exp31='[[ "$cwd" =~ (~?/)(.*/)([^/]*)$ ]]'
        if  eval $exp31 ;  then  # only valid if path have more then 1 dir
                local path_head=${BASH_REMATCH[1]}
                local path_middle=${BASH_REMATCH[2]}
                local path_last_dir=${BASH_REMATCH[3]}

                local cwd_middle_max=$(( $cwd_max_length - ${#path_last_dir} ))
                [[ $cwd_middle_max < 0  ]]  &&  cwd_middle_max=0


		# trunc middle if over limit
                if [ ${#path_middle}   -gt   $(( $cwd_middle_max + ${#elipses_marker} + 5 )) ];   then
			
                    # truncate
                    middle_tail=${path_middle:${#path_middle}-${cwd_middle_max}}

                    # trunc on dir boundary (trunc 1st, probably tuncated dir)
                    exp31='[[ $middle_tail =~ [^/]*/(.*)$ ]]'
                    eval $exp31
                    middle_tail=${BASH_REMATCH[1]}

                    # use truncated only if we cut at least 4 chars
                    if [ $((  ${#path_middle} - ${#middle_tail}))  -gt 4  ];  then
                        cwd=$path_head$elipses_marker$middle_tail$path_last_dir
                    fi
                fi
        fi
        return
 }

###################################################### ID (user name)
        id=`id -un`
        id=${id#$default_user}

########################################################### TTY
        tty=`tty 2>/dev/null`
        tty=`echo $tty | sed "s:/dev/pts/:p:; s:/dev/tty::" `           # RH tty devs
        tty=`echo $tty | sed "s:/dev/vc/:vc:" `                         # gentoo tty devs

        if [ "$TERM" = "screen" ] ;  then

                #       [ "$WINDOW" = "" ] && WINDOW="?"
                #
                #               # if under screen then make tty name look like s1-p2
                #               # tty="${WINDOW:+s}$WINDOW${WINDOW:+-}$tty"
                #       tty="${WINDOW:+s}$WINDOW"  # replace tty name with screen number
                tty="$WINDOW"  # replace tty name with screen number
        fi

        # we don't need tty name under X11
        case $TERM in
                xterm* | rxvt* | gnome-terminal | konsole | eterm* | wterm | cygwin)  unset tty ;;
                *);;
        esac

        dir_color=${!dir_color}
        rc_color=${!rc_color}
        user_id_color=${!user_id_color}
        root_id_color=${!root_id_color}

        ########################################################### HOST
        ### we don't display home host/domain  $SSH_* set by SSHD or keychain

        # How to find out if session is local or remote? Working with "su -", ssh-agent, and so on ?

        ## is sshd our parent?
        # if    { for ((pid=$$; $pid != 1 ; pid=`ps h -o pid --ppid $pid`)); do ps h -o command -p $pid; done | grep -q sshd && echo == REMOTE ==; }
        #then

        host=${HOSTNAME}
        if [[ $short_hostname = "on" ]]; then
          if [[ "$(uname -s)" = MINGW* ]]; then
            host=$(hostname)
          elif [[ "$(uname)" = CYGWIN* ]]; then
	    host=`hostname`
	  else
	   host=`hostname -s`
	  fi
        fi
        host=${host#$default_host}
        uphost=`echo ${host} | tr a-z-. A-Z_`
        if [[ $upcase_hostname = "on" ]]; then
                host=${uphost}
        fi

	h_color=${uphost}_host_color
	h_color=${!h_color}
		
        if [[ -z $h_color ]] ;  then
	   h_color=$host_color
	   h_color=${!h_color}
	fi
		
        if [[ -z $h_color && -x /usr/bin/cksum ]] ;  then
            cksum_color_no=`echo $uphost | cksum  | awk '{print $1%14}'`
            color_index=(green GREEN red RED yellow YELLOW blue BLUE magenta MAGENTA cyan CYAN white WHITE)              # FIXME:  bw,  color-256
            h_color=${color_index[cksum_color_no]}
	    h_color=${!h_color}
        fi
      
        # we might already have short host name
        host=${host%.$default_domain}

#################################################################### WHO_WHERE
        #  [[user@]host[-tty]]

        if [[ -n $id  || -n $host ]] ;   then
                [[ -n $id  &&  -n $host ]]  &&  at='@'  || at=''
                color_who_where="${id}${host:+$h_color$at$host}${tty:+ $tty}"
                plain_who_where="${id}$at$host"

                # add trailing " "
                color_who_where="$color_who_where "
                plain_who_where="$plain_who_where "

                # if root then make it root_color
                if [ "$id" == "root" ]  ; then
                        user_id_color=$root_id_color
                        prompt_char="$root_prompt_char"
                fi
                color_who_where="$user_id_color$color_who_where$colors_reset"
        else
                color_who_where=''
        fi


parse_g2_status() {

        local git_dir=`"$GIT_EXE" rev-parse --git-dir 2> /dev/null`
        [[  -n ${git_dir/./} ]] || return

        #### PARSE STATUS
        local untracked_files=0 added_files=0 modified_files=0

        if [[ $("$GIT_EXE" config --global --bool --get g2.prompt.countfiles 2>/dev/null) != false ]]; then
            IFS=$'\n'
            local git_status line x y
            git_status="$("$GIT_EXE" status --porcelain 2> /dev/null)"

             for line in $git_status; do
              x=${line:0:1}; y=${line:1:1};
              if [[ $x = '?' ]]; then
                 let untracked_files++
              else
                 [[ $x != ' ' ]] && let added_files++
                 [[ $y != ' ' ]] && let modified_files++
              fi
             done
        fi


        ####  GET GIT OP
        local   modified added init detached

        # Figures the state of the repo
        local op=""
		local branch=""
		local step=""
		local total=""


        $("$GIT_EXE" ls-tree HEAD &>/dev/null)
        [[ $? -eq 128 ]] && init=init || {

            if [ -d "$git_dir/rebase-merge" ]; then

                step=$(cat "$git_dir/rebase-merge/msgnum")
                total=$(cat "$git_dir/rebase-merge/end")
                branch="$(cat "$git_dir/rebase-merge/head-name") $step/$total"
                if [ -f "$git_dir/rebase-merge/interactive" ]; then
                    op="rebase -i"
                else
                    op="rebase -m"
                fi
            else
                if [ -d "$git_dir/rebase-apply" ]; then
                    step=$(cat "$git_dir/rebase-apply/next")
                    total=$(cat "$git_dir/rebase-apply/last")
                    if [ -f "$git_dir/rebase-apply/rebasing" ]; then
                        op="rebase"
                    elif [ -f "$git_dir/rebase-apply/applying" ]; then
                        op="am"
                    else
                        op="am/rebase"
                    fi
                elif [ -f "$git_dir/MERGE_HEAD" ]; then
                    op="merge"
                elif [ -f "$git_dir/CHERRY_PICK_HEAD" ]; then
                    op="cherrypick"
                elif [ -f "$git_dir/REVERT_HEAD" ]; then
                    op="revert"
                elif [ -f "$git_dir/BISECT_LOG" ]; then
                    op="bisect"
                fi

                branch="$($GIT_EXE symbolic-ref HEAD 2>/dev/null)" || {
                    [ -z "$op" ] && op="detached" && detached=detached
                    branch="$(
                    case "${GIT_PS1_DESCRIBE_STYLE-}" in
                    (contains)
                        $GIT_EXE describe --contains HEAD ;;
                    (branch)
                        $GIT_EXE describe --contains --all HEAD ;;
                    (describe)
                        $GIT_EXE describe HEAD ;;
                    (* | default)
                        $GIT_EXE describe --tags --exact-match HEAD ;;
                    esac 2>/dev/null)" ||

                    branch="$(cut -c1-7 "$git_dir/HEAD" 2>/dev/null)..." ||
                    branch="unknown"

                    if [ -n "$step" ] && [ -n "$total" ]; then
                        branch="$branch $step/$total"
                    fi
                    branch="[$branch]"
                }
            fi
        }
        ####  GET GIT HEX-REVISION
        local rawhex=""
        if  [[ $rawhex_len -gt 0 ]] ;  then
                rawhex=`"$GIT_EXE" rev-parse HEAD 2>/dev/null`
                rawhex=${rawhex/HEAD/}
                rawhex="=$hex_vcs_color${rawhex:0:$rawhex_len}"
        fi

       #### remove junk from branch name, substitute master to M
       branch=${branch/#refs\/heads\//}
       branch=${branch/#master/M}

        ### compose vcs_info
        local vcs_info
        if [ $init ];  then
                vcs_info=${WHITE}init
        else
            if [ "$op" ];  then
                branch="$op:$branch"
            fi
            vcs_info="$branch$rawhex"
        fi

        ### status:  choose primary (for branch color)
        local status=${op:+op}
        status=${status:-$detached}
        status=${status:-$clean}
        status=${status:-$modified}
        status=${status:-$added}
        status=${status:-$untracked}
        status=${status:-$init}
        # at least one should be set
        : ${status?prompt internal error: git status}
        eval vcs_color="\${${status}_vcs_color}"

       ### file list
        local status_info=""
        [[ $added_files -gt 0     ]]  &&  status_info+=" "${added_vcs_color}+$added_files
        [[ $modified_files -gt 0  ]]  &&  status_info+=" "${modified_vcs_color}*$modified_files
        [[ $untracked_files -gt 0 ]]  &&  status_info+=" "${untracked_vcs_color}?$untracked_files

        head_local="$vcs_color(${vcs_info}$vcs_color${status_info}$vcs_color)"
        head_local="${head_local+$vcs_color$head_local }"
 }

###################################################################### PROMPT_COMMAND

prompt_command_function() {

        rc="$?"
        if [[ "$rc" == "0" ]]; then
                rc=""
        else
                rc="$rc_color$rc$colors_reset "
        fi

        local cwd=${PWD/$HOME/\~}     # substitute  "~"

        parse_g2_status

        # if cwd_cmd have back-slash, then assign it value to cwd
        # else eval cwd_cmd,  cwd should have path after execution
        eval "${cwd_cmd/\\/cwd=\\\\}"

        PS1="$goto_1col$colors_reset$rc$head_local$color_who_where\n$dir_color$cwd$dir_color$prompt_char $colors_reset"

        unset head_local pwd
 }

unset rc id tty
PROMPT_COMMAND=prompt_command_function
