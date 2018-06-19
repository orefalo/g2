# fish completion for git
# Use 'command git' to avoid interactions for aliases from git to (e.g.) hub

function __g2_prompt_branches
  command git branch --no-color -a ^/dev/null | grep -v 'remotes/' | sed -e 's/^..//' -e 's/^remotes\///'
end

function __g2_prompt_remotebranches
  __g2_prompt_branches | grep /
end

function __g2_prompt_tags
  command git tag
end

function __g2_prompt_heads
  __g2_prompt_branches
  __g2_prompt_tags
end

function __g2_prompt_remotes
  command git remote
end

# commit hashs
function __g2_prompt_getcommithash
  command git log --no-merges --pretty=format:"%h" --since=1.weeks
end

# merge commit hashes
function __g2_prompt_getmergecommithash
  command git log --merges --pretty=format:"%h" --since=1.weeks
end

# files changed in workspace
function __g2_prompt_modified_files
  command git ls-files -m --exclude-standard ^/dev/null
end

# files modified
function __g2_prompt_add_files
  command git ls-files -mo --exclude-standard ^/dev/null
end

# files in staging area
function __g2_prompt_fileinstaging
  command git diff --cached --name-only --relative .
end

function __g2_prompt_ranges
  set -l from (commandline -ot | perl -ne 'if (index($_, "..") > 0) { my @parts = split(/\.\./); print $parts[0]; }')
  if test -z "$from"
    __g2_prompt_branches
    return 0
  end

  set -l to (commandline -ot | perl -ne 'if (index($_, "..") > 0) { my @parts = split(/\.\./); print $parts[1]; }')
  for from_ref in (__g2_prompt_heads | sgrep -e "$from")
    for to_ref in (__g2_prompt_heads | sgrep -e "$to")
      printf "%s..%s\n" $from_ref $to_ref
    end
  end
end

function __g2_prompt_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 ]
    switch $cmd[1]
      case 'g' 'git'
        return 0
    end
  end
  return 1
end

function __g2_prompt_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end

    # aliased command
    set -l aliased (command git config --get "alias.$cmd[2]" ^ /dev/null | sed 's/ .*$//')
    if [ $argv[1] = "$aliased" ]
      return 0
    end
  end
  return 1
end

# general options
complete -f -c g -n 'not __g2_prompt_needs_command' -l help -d 'Display the manual of a git command'

# abort
complete -f -c g -n '__g2_prompt_needs_command' -a 'abort' -d 'Aborts any rebase/merge'

# am
complete -f -c g -n '__g2_prompt_needs_command' -a 'am' -d 'Amends last commit with content from the staging area'
complete -f -c g -n '__g2_prompt_using_command am' -s f -l verbose -d 'Force amends'

# br
complete -f -c g -n '__g2_prompt_needs_command' -a 'br' -d 'List, create, or delete branches'
complete -f -c g -n '__g2_prompt_using_command br' -a '(__g2_prompt_branches)' -d 'Branch'
complete -f -c g -n '__g2_prompt_using_command br' -s d -d 'Delete branch'
complete -f -c g -n '__g2_prompt_using_command br' -s D -d 'Force deletion of branch'
complete -f -c g -n '__g2_prompt_using_command br' -s m -d 'Rename branch'
complete -f -c g -n '__g2_prompt_using_command br' -s M -d 'Force renaming branch'
complete -f -c g -n '__g2_prompt_using_command br' -s a -d 'Lists both local and remote branches'
complete -f -c g -n '__g2_prompt_using_command br' -s t -l track -d 'Track remote branch'
complete -f -c g -n '__g2_prompt_using_command br' -l no-track -d 'Do not track remote branch'
complete -f -c g -n '__g2_prompt_using_command br' -l set-upstream -d 'Set remote branch to track'

# bs
complete -f -c g -n '__g2_prompt_needs_command' -a 'bs' -d 'Find the change that introduced a bug by binary search'

# co
complete -f -c g -n '__g2_prompt_needs_command'    -a 'co' -d 'Checkout and switch to a branch'
complete -f -c g -n '__g2_prompt_using_command co' -a '(__g2_prompt_branches)' --description 'Branch'
complete -f -c g -n '__g2_prompt_using_command co' -a '(__g2_prompt_tags)' --description 'Tag'
complete -f -c g -n '__g2_prompt_using_command co' -a '(__g2_prompt_modified_files)' --description 'File'
complete -f -c g -n '__g2_prompt_using_command co' -s b -d 'Create a new branch'
complete -f -c g -n '__g2_prompt_using_command co' -s t -l track -d 'Track a new branch'

complete -f -c g -n '__g2_prompt_needs_command' -a 'continue' -d 'Resumes conflict resolution process'

# cp
complete -f -c g -n '__g2_prompt_needs_command' -a 'cp' -d 'Apply the change introduced by an existing commit'
complete -f -c g -n '__g2_prompt_using_command cp' -a '(__g2_prompt_branches)' -d 'Branch'

# co
complete -f -c g -n '__g2_prompt_needs_command'    -a 'ci' -d 'Record changes to the repository'
complete -f -c g -n '__g2_prompt_using_command ci' -s m -l message -d 'Use the given <msg> as the commit message.'

# clone
complete -f -c g -n '__g2_prompt_needs_command' -a 'clone' -d 'Clone a repository into a new directory'

# df
complete -c g -n '__g2_prompt_needs_command'    -a 'df' -d 'Show changes between commits, commit and working tree, etc'
complete -c g -n '__g2_prompt_using_command df' -a '(__g2_prompt_ranges)' -d 'Branch'
complete -c g -n '__g2_prompt_using_command df' -l cached -d 'Show diff of changes in the index'

# dt
complete -c g -n '__g2_prompt_needs_command'    -a 'dt' -d 'Open diffs in a visual tool'
complete -c g -n '__g2_prompt_using_command dt' -a '(__g2_prompt_ranges)' -d 'Branch'
complete -c g -n '__g2_prompt_using_command dt' -l cached -d 'Visually show diff of changes in the index'

# fetch
complete -f -c g -n '__g2_prompt_needs_command' -a fetch -d 'Download objects and refs from another repository'
complete -f -c g -n '__g2_prompt_using_command fetch' -a '(__g2_prompt_remotes)' -d 'Remote'
complete -f -c g -n '__g2_prompt_using_command fetch' -s q -l quiet -d 'Be quiet'
complete -f -c g -n '__g2_prompt_using_command fetch' -s v -l verbose -d 'Be verbose'
complete -f -c g -n '__g2_prompt_using_command fetch' -s a -l append -d 'Append ref names and object names'
# TODO --upload-pack
complete -f -c g -n '__g2_prompt_using_command fetch' -s f -l force -d 'Force update of local branches'

# freeze
complete -c g -n '__g2_prompt_needs_command'    -a freeze -d 'Freezes file contents to the index'
complete -f -c g -n '__g2_prompt_using_command freeze' -s m -l message -d 'Create a commit using the given <msg>.'
complete -f -c g -n '__g2_prompt_using_command freeze; and __fish_contains_opt -s p patch' -a '(__g2_prompt_modified_files)'
complete -f -c g -n '__g2_prompt_using_command freeze' -a '(__g2_prompt_add_files)'

# unfreeze
complete -c g -n '__g2_prompt_needs_command'    -a unfreeze -d 'UnFreezes file contents from the index'
complete -f -c g -n '__g2_prompt_using_command unfreeze; and __fish_contains_opt -s p patch' -a '(__g2_prompt_modified_files)'
complete -f -c g -n '__g2_prompt_using_command unfreeze' -a '(__g2_prompt_fileinstaging)'

#gc
complete -f -c g -n '__g2_prompt_needs_command' -a 'gc' -d 'Garbage collects and cleansup the repository'

# gp
complete -c g -n '__g2_prompt_needs_command'    -a 'gp' -d 'Print lines matching a pattern'

# gui
complete -c g -n '__g2_prompt_needs_command'    -a 'gui' -d 'Opens git gui'

# ig
complete -c g -n '__g2_prompt_needs_command'    -a 'ig' -d 'adds pattern to .ignore file'

# init
complete -f -c g -n '__g2_prompt_needs_command' -a 'init' -d 'Create an empty git repository or reinitialize an existing one'

# key
complete -c g -n '__g2_prompt_needs_command'    -a 'key' -d 'Displays your ssh public key'
complete -f -c g -n '__g2_prompt_using_command key' -s gen -d 'Generates a new ssh identify'

# mg
complete -f -c g -n '__g2_prompt_needs_command' -a 'mg' -d 'Join two or more development histories together'
complete -f -c g -n '__g2_prompt_using_command mg' -a '(__g2_prompt_branches)' -d 'Branch'
complete -f -c g -n '__g2_prompt_using_command mg' -l commit -d "Autocommit the merge"
complete -f -c g -n '__g2_prompt_using_command mg' -l no-commit -d "Don't autocommit the merge"
complete -f -c g -n '__g2_prompt_using_command mg' -l edit -d 'Edit auto-generated merge message'
complete -f -c g -n '__g2_prompt_using_command mg' -l no-edit -d "Don't edit auto-generated merge message"
complete -f -c g -n '__g2_prompt_using_command mg' -l ff -d "Don't generate a merge commit if merge is fast-forward"
complete -f -c g -n '__g2_prompt_using_command mg' -l no-ff -d "Generate a merge commit even if merge is fast-forward"
complete -f -c g -n '__g2_prompt_using_command mg' -l ff-only -d 'Refuse to merge unless fast-forward possible'
complete -f -c g -n '__g2_prompt_using_command mg' -l log -d 'Populate the log message with one-line descriptions'
complete -f -c g -n '__g2_prompt_using_command mg' -l no-log -d "Don't populate the log message with one-line descriptions"
complete -f -c g -n '__g2_prompt_using_command mg' -l stat -d "Show diffstat of the merge"
complete -f -c g -n '__g2_prompt_using_command mg' -s n -l no-stat -d "Don't show diffstat of the merge"
complete -f -c g -n '__g2_prompt_using_command mg' -l squash -d "Squash changes from other branch as a single commit"
complete -f -c g -n '__g2_prompt_using_command mg' -l no-squash -d "Don't squash changes"
complete -f -c g -n '__g2_prompt_using_command mg' -s q -l quiet -d 'Be quiet'
complete -f -c g -n '__g2_prompt_using_command mg' -s v -l verbose -d 'Be verbose'
complete -f -c g -n '__g2_prompt_using_command mg' -l progress -d 'Force progress status'
complete -f -c g -n '__g2_prompt_using_command mg' -l no-progress -d 'Force no progress status'
complete -f -c g -n '__g2_prompt_using_command mg' -s m -d 'Set the commit message'
complete -f -c g -n '__g2_prompt_using_command mg' -l abort -d 'Abort the current conflict resolution process'

# mt
complete -f -c g -n '__g2_prompt_needs_command' -a 'mt' -d 'Visually resolve conflicts'

# mv
complete -c g -n '__g2_prompt_needs_command'    -a 'mv' -d 'Move or rename a file, a directory, or a symlink'

# lg
complete -c g -n '__g2_prompt_needs_command'    -a 'lg' -d 'Show commit logs'
complete -c g -n '__g2_prompt_using_command lg' -a '(__g2_prompt_heads) (__g2_prompt_ranges)' -d 'Branch'
complete -f -c g -n '__g2_prompt_using_command lg' -l pretty -a 'oneline short medium full fuller email raw format:'

# ls
complete -c g -n '__g2_prompt_needs_command'    -a 'ls' -d 'Lists files under source control'

# panic
complete -f -c g -n '__g2_prompt_needs_command'    -a 'panic' -d 'Checks out HEAD, clean all untracked files'

# push
complete -f -c g -n '__g2_prompt_needs_command' -a 'push' -d 'Update remote refs along with associated objects'
complete -f -c g -n '__g2_prompt_using_command push' -a '(git remote)' -d 'Remote alias'
complete -f -c g -n '__g2_prompt_using_command push' -a '(__g2_prompt_branches)' -d 'Branch'
complete -f -c g -n '__g2_prompt_using_command push' -l all -d 'Push all refs under refs/heads/'
complete -f -c g -n '__g2_prompt_using_command push' -l prune -d "Remove remote branches that don't have a local counterpart"
complete -f -c g -n '__g2_prompt_using_command push' -l mirror -d 'Push all refs under refs/'
complete -f -c g -n '__g2_prompt_using_command push' -l delete -d 'Delete all listed refs from the remote repository'
complete -f -c g -n '__g2_prompt_using_command push' -l tags -d 'Push all refs under refs/tags'
complete -f -c g -n '__g2_prompt_using_command push' -s n -l dry-run -d 'Do everything except actually send the updates'
complete -f -c g -n '__g2_prompt_using_command push' -l porcelain -d 'Produce machine-readable output'
complete -f -c g -n '__g2_prompt_using_command push' -s f -l force -d 'Force update of remote refs'
complete -f -c g -n '__g2_prompt_using_command push' -s u -l set-upstream -d 'Add upstream (tracking) reference'
complete -f -c g -n '__g2_prompt_using_command push' -s q -l quiet -d 'Be quiet'
complete -f -c g -n '__g2_prompt_using_command push' -s v -l verbose -d 'Be verbose'
complete -f -c g -n '__g2_prompt_using_command push' -l progress -d 'Force progress status'
# TODO --recurse-submodules=check|on-demand

# pull
complete -f -c g -n '__g2_prompt_needs_command' -a 'pull' -d 'Fetch from and merge with another repository or a local branch'
complete -f -c g -n '__g2_prompt_using_command pull' -s q -l quiet -d 'Be quiet'
complete -f -c g -n '__g2_prompt_using_command pull' -s v -l verbose -d 'Be verbose'
# Options related to fetching
complete -f -c g -n '__g2_prompt_using_command pull' -l all -d 'Fetch all remotes'
complete -f -c g -n '__g2_prompt_using_command pull' -s a -l append -d 'Append ref names and object names'
complete -f -c g -n '__g2_prompt_using_command pull' -s f -l force -d 'Force update of local branches'
complete -f -c g -n '__g2_prompt_using_command pull' -s k -l keep -d 'Keep downloaded pack'
complete -f -c g -n '__g2_prompt_using_command pull' -l no-tags -d 'Disable automatic tag following'
# TODO --upload-pack
complete -f -c g -n '__g2_prompt_using_command pull' -l progress -d 'Force progress status'
complete -f -c g -n '__g2_prompt_using_command pull' -a '(git remote)' -d 'Remote alias'
complete -f -c g -n '__g2_prompt_using_command pull' -a '(__g2_prompt_branches)' -d 'Branch'

# rb
complete -f -c g -n '__g2_prompt_needs_command' -a 'rb' -d 'Forward-port local commits to the updated upstream head'
complete -f -c g -n '__g2_prompt_using_command rb' -a '(git remote)' -d 'Remote alias'
complete -f -c g -n '__g2_prompt_using_command rb' -a '(__g2_prompt_branches)' -d 'Branch'
complete -f -c g -n '__g2_prompt_using_command rb' -l continue -d 'Restart the rebasing process'
complete -f -c g -n '__g2_prompt_using_command rb' -l abort -d 'Abort the rebase operation'
complete -f -c g -n '__g2_prompt_using_command rb' -l keep-empty -d "Keep the commits that don't cahnge anything"
complete -f -c g -n '__g2_prompt_using_command rb' -l skip -d 'Restart the rebasing process by skipping the current patch'
complete -f -c g -n '__g2_prompt_using_command rb' -s m -l merge -d 'Use merging strategies to rebase'
complete -f -c g -n '__g2_prompt_using_command rb' -s q -l quiet -d 'Be quiet'
complete -f -c g -n '__g2_prompt_using_command rb' -s v -l verbose -d 'Be verbose'
complete -f -c g -n '__g2_prompt_using_command rb' -l stat -d "Show diffstat of the rebase"
complete -f -c g -n '__g2_prompt_using_command rb' -s n -l no-stat -d "Don't show diffstat of the rebase"
complete -f -c g -n '__g2_prompt_using_command rb' -l verify -d "Allow the pre-rebase hook to run"
complete -f -c g -n '__g2_prompt_using_command rb' -l no-verify -d "Don't allow the pre-rebase hook to run"
complete -f -c g -n '__g2_prompt_using_command rb' -s f -l force-rebase -d 'Force the rebase'
complete -f -c g -n '__g2_prompt_using_command rb' -s i -l interactive -d 'Interactive mode'
complete -f -c g -n '__g2_prompt_using_command rb' -s p -l preserve-merges -d 'Try to recreate merges'
complete -f -c g -n '__g2_prompt_using_command rb' -l root -d 'Rebase all reachable commits'
complete -f -c g -n '__g2_prompt_using_command rb' -l autosquash -d 'Automatic squashing'
complete -f -c g -n '__g2_prompt_using_command rb' -l no-autosquash -d 'No automatic squashing'
complete -f -c g -n '__g2_prompt_using_command rb' -l no-ff -d 'No fast-forward'

# rm
complete -c g -n '__g2_prompt_needs_command'    -a 'rm'     -d 'Remove files from the working tree and from the index'
complete -c g -n '__g2_prompt_using_command rm' -f
complete -c g -n '__g2_prompt_using_command rm' -l cached -d 'Keep local copies'
complete -c g -n '__g2_prompt_using_command rm' -l ignore-unmatch -d 'Exit with a zero status even if no files matched'
complete -c g -n '__g2_prompt_using_command rm' -s r -d 'Allow recursive removal'
complete -c g -n '__g2_prompt_using_command rm' -s q -l quiet -d 'Be quiet'
complete -c g -n '__g2_prompt_using_command rm' -s f -l force -d 'Override the up-to-date check'
complete -c g -n '__g2_prompt_using_command rm' -s n -l dry-run -d 'Dry run'

# rs
complete -c g -n '__g2_prompt_needs_command'    -a 'rs' -d 'Reset current HEAD to the specified state'
complete -f -c g -n '__g2_prompt_using_command rs' -l hard -d 'Reset files in working directory'
complete -c g -n '__g2_prompt_using_command rs' -a '(__g2_prompt_branches)'

# rt
complete -f -c g -n '__g2_prompt_needs_command' -a rt -d 'Manage set of tracked repositories'
complete -f -c g -n '__g2_prompt_using_command rt' -a '(__g2_prompt_remotes)'
complete -f -c g -n '__g2_prompt_using_command rt' -s v -l verbose -d 'Be verbose'
complete -f -c g -n '__g2_prompt_using_command rt' -a add -d 'Adds a new remote'
complete -f -c g -n '__g2_prompt_using_command rt' -a rm -d 'Removes a remote'
complete -f -c g -n '__g2_prompt_using_command rt' -a show -d 'Shows a remote'
complete -f -c g -n '__g2_prompt_using_command rt' -a prune -d 'Deletes all stale tracking branches'
complete -f -c g -n '__g2_prompt_using_command rt' -a update -d 'Fetches updates'

# rv
complete -f -c g -n '__g2_prompt_needs_command' -a 'rv' -d 'Revert an existing commit'

# server
complete -f -c g -n '__g2_prompt_needs_command' -a 'server' -d 'Starts a local git:// server on current repo'

# setup
complete -f -c g -n '__g2_prompt_needs_command' -a 'setup' -d 'Runs the Git confirguration tool'

# sh
complete -f -c g -n '__g2_prompt_needs_command' -a 'sh' -d 'Shows the last commit details'
complete -f -c g -n '__g2_prompt_using_command sh' -a '(__g2_prompt_branches)' -d 'Branch'

# sm
complete -f -c g -n '__g2_prompt_needs_command' -a 'sm' -d 'Initialize, update or inspect submodules'
complete -f -c g -n '__g2_prompt_using_command sm' -a 'add' -d 'Add a submodule'
complete -f -c g -n '__g2_prompt_using_command sm' -a 'status' -d 'Show submodule status'
complete -f -c g -n '__g2_prompt_using_command sm' -a 'init' -d 'Initialize all submodules'
complete -f -c g -n '__g2_prompt_using_command sm' -a 'update' -d 'Update all submodules'
complete -f -c g -n '__g2_prompt_using_command sm' -a 'summary' -d 'Show commit summary'
complete -f -c g -n '__g2_prompt_using_command sm' -a 'foreach' -d 'Run command on each submodule'
complete -f -c g -n '__g2_prompt_using_command sm' -a 'sync' -d 'Sync submodules URL with .gitmodules'

### ss
complete -c g -n '__g2_prompt_needs_command' -a 'ss' -d 'Stash away changes'
complete -f -c g -n '__g2_prompt_using_command ss' -a list -d 'List stashes'
complete -f -c g -n '__g2_prompt_using_command ss' -a show -d 'Show the changes recorded in the stash'
complete -f -c g -n '__g2_prompt_using_command ss' -a pop -d 'Apply and remove a single stashed state'
complete -f -c g -n '__g2_prompt_using_command ss' -a apply -d 'Apply a single stashed state'
complete -f -c g -n '__g2_prompt_using_command ss' -a clear -d 'Remove all stashed states'
complete -f -c g -n '__g2_prompt_using_command ss' -a drop -d 'Remove a single stashed state from the stash list'
complete -f -c g -n '__g2_prompt_using_command ss' -a create -d 'Create a stash'
complete -f -c g -n '__g2_prompt_using_command ss' -a save -d 'Save a new stash'
complete -f -c g -n '__g2_prompt_using_command ss' -a branch -d 'Create a new branch from a stash'

### st
complete -f -c g -n '__g2_prompt_needs_command' -a 'st' -d 'Show the working tree status'
complete -f -c g -n '__g2_prompt_using_command st' -s s -l short -d 'Give the output in the short-format'
complete -f -c g -n '__g2_prompt_using_command st' -s b -l branch -d 'Show the branch and tracking info even in short-format'
complete -f -c g -n '__g2_prompt_using_command st'      -l porcelain -d 'Give the output in a stable, easy-to-parse format'
complete -f -c g -n '__g2_prompt_using_command st' -s z -d 'Terminate entries with null character'
complete -f -c g -n '__g2_prompt_using_command st' -s u -l untracked-files -x -a 'no normal all' -d 'The untracked files handling mode'
complete -f -c g -n '__g2_prompt_using_command st' -l ignore-submodules -x -a 'none untracked dirty all' -d 'Ignore changes to submodules'

### sync
complete -f -c g -n '__g2_prompt_needs_command' -a 'sync' -d 'Synchronizes working branch with remote'

### tg
complete -f -c g -n '__g2_prompt_needs_command' -a 'tg' -d 'Create, list, delete or verify a tag object signed with GPG'
complete -f -c g -n '__g2_prompt_using_command tg ; and __fish_not_contain_opt -s d; and __fish_not_contain_opt -s v; and test (count (commandline -opc | sgrep -v -e \'^-\')) -eq 3' -a '(__g2_prompt_branches)' -d 'Branch'
complete -f -c g -n '__g2_prompt_using_command tg' -s a -l annotate -d 'Make an unsigned, annotated tag object'
complete -f -c g -n '__g2_prompt_using_command tg' -s s -l sign -d 'Make a GPG-signed tag'
complete -f -c g -n '__g2_prompt_using_command tg' -s d -l delete -d 'Remove a tag'
complete -f -c g -n '__g2_prompt_using_command tg' -s v -l verify -d 'Verify signature of a tag'
complete -f -c g -n '__g2_prompt_using_command tg' -s f -l force -d 'Force overwriting exising tag'
complete -f -c g -n '__g2_prompt_using_command tg' -s l -l list -d 'List tags'
complete -f -c g -n '__fish_contains_opt -s d' -a '(__g2_prompt_tags)' -d 'Tag'
complete -f -c g -n '__fish_contains_opt -s v' -a '(__g2_prompt_tags)' -d 'Tag'

# track
complete -f -c g -n '__g2_prompt_needs_command' -a 'track' -d 'Displays/set remote branch tracking'
complete -f -c g -n '__g2_prompt_using_command track' -a '(__g2_prompt_remotebranches)'

#  undo <file>|commit|merge - reverts changes
complete -c g -n '__g2_prompt_needs_command' -a 'undo' -d 'Undo a file, a last commit or last merge'
complete -f -c g -n '__g2_prompt_using_command undo' -a commit -d 'Undo the last commit'
complete -f -c g -n '__g2_prompt_using_command undo' -a merge -d 'Undo the last merge'

# version
complete -f -c g -n '__g2_prompt_needs_command' -a 'version' -d 'Displays G2 version information'

# wip
complete -f -c g -n '__g2_prompt_needs_command' -a 'wip' -d 'Pushes Work In Progress on the index '

#unwip
complete -f -c g -n '__g2_prompt_needs_command' -a 'unwip' -d 'Pulls Work In Progress from the index'
