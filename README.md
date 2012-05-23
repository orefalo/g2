
![image](http://orefalo.github.com/g2/images/G2.jpg)

##Introduction

I see it every day, beginners have a hard time picking up **git**. Aside from the DSCM concepts, the command line is not easy: it is aimed at people who know git.. advanced nerds, not beginners.

This project is an attempt to make the git command line a friendly place: it eases the learning process by providing guidance and high level commands.

###Benefits

* **g2** helps setup git settings : sshkeys, username, email & tools.
* **g2** warns before any destructive operation.
* **g2** provides two letter acronyms for most commands.
* **g2** provides a reduced set of commands which give guidance on what to do next.
* **g2** enhances command line experience with TAB completion & a smart prompt.
* **g2** warns when a branch history was changed on the server (forced pushed).
* **g2** checks the fresheshness of the branch prior to merging and warns accordingly.
* **g2** enforces new commands to force developers into a clean linear history.
* **g2** requires a clean state before rebasing, checking out, branching or merging.
* **g2** provides guidance when it cannot perform an operation.
* **g2** brings a number of friendly commands such as : panic, sync, freeze, wip.
* **g2** eases branch creation.

###What G2 is not

* A replacement for **git**. Rather, g2 is a layer on top of git
* A magic way to learn GIT. It will help by providing guidance but you will still need to understand how git works.

##Installation

**PRE-REQUISITES**: 

* **g2** is a layer on top of git, If you are doing a manual install, a recent version of git must be pre-installed.
* Please backup your favorite ~/.gitconfig as g2 with recreate it from scratch.


###Linux (RedHat/Ubuntu):

Please clone the repository, edit either **/etc/bashrc**, **/etc/bash.bashrc** or **~/.bashrc** and add the following code:

    [[ $PS1 && -f /path/to/g2-install.sh ]] && \
         . /path/to/g2-install.sh

###MacOS:

Same as Linux, make the change in `~/.bash_profile`

The software will soon be available via a [HomeBrew](http://mxcl.github.com/homebrew/) package, stay tuned.


###Solaris (Partially tested):

Add the following script to **/etc/bashrc** or **~/.bashrc** (or any other file sourcing those).

    PATH=/usr/xpg4/bin:$PATH
    export PATH
    [[ $PS1 && -f /path/to/g2-install.sh ]] && \
         . /path/to/g2-install.sh

###Windows:

Git is not a prerequisit on windows as the installer comes bundled with it.

Please download the Windows native installer from [https://github.com/downloads/orefalo/g2/Git-1.7.10.exe](https://github.com/downloads/orefalo/g2/Git-1.7.10.exe).


##How to use

The project introduces the `g` alias. Taken without parameters it displays the following output.

```
$ g
Usage:
	abort - aborts any rebase/merge
	am <?-f> - amends last commit with staging area
	br <?branch> - list or create branches
	bs - bisect
	co <branch> - switches branch (either local/remote)
	cp <commit> - cherry-pick
	ci <?params...> - commit
	clone <url> - clone a remote repository
	df/dt <?params...> - compares files
	fetch - synchronizes remote branches
	freeze/unfreeze <?-m comment> <?file> - freeze/unfreeze files
	gc - garbage collects: run fsck & gc
	gp - grep
	gui - launches the GUI
	ig <file> - adds to gitignore & removes from source control
	init <folder> - init a repository
	key <?-gen> - displays/generates your ssh public key
	mg <?params...> <branch> - merge
	mt <?params...> - fixes conflicts by opening a visual mergetool
	mv - move (rename) a file
	lg - displays commit log
	ls <?params...> - list files under source control
	panic - gets you back on HEAD, cleans all untracked files
	pull/push <?opts> <remote> <branch> - deals with other branches
	rb <?params...> <branch> - rebase
	rm <params...> - remove
	rs <params...> - reset
	rs upstream - resets branch to upstream state
	rt <?params...> - remote
	rv <commit> - revert
	setup - configures user, key, editor, tools
	sh <?-deep> - show commit contents
	sm <?params...> - submodule
	st <?params...> - status
	sync - syncs working branch: fetch, rebase & push
	tg - tag
	track <?upstream_branch> - shows/set tracking
	wip/unwip - save/restore work in progress to branch
```

On top of providing two letters acronyms for most git commands, **g2** has interesting features which enhance command line experience.

###Setup

`g setup` and `g key` are two handy commands to setup username, email, keys, editor and tooling.

![image](http://orefalo.github.com/g2/images/setup.png)


At anytime, you may display your ssh key with: `g key`

```
$ git key
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDYUTgzU9zjsdda9WBEED5bH+SVMq5bYoIxPSzop2IqUBoyyOlRdHt4dy2r/MWiB2eKQOQmPRE7SeawhFWYbCwEdi6BtEe8m4PiZd3OIRV13TlPj54Hi6Q1Ab8emEAH026L4kwef46+j0aJf/7tZzUw/uZW9Wrnf1VN+J1VlWvmYaG9JpPBuatAlTV9rhCeQ2WO39KYWVYJxH1mO0zPEpuTBojji7HYJtlS4OCKgY9mCVBPiUzzLfmrlIhZz+k5rMWv6i4tQtats23qtHEOi9GxJm4+TSGLwM89/C186CJ+8Yx0g/c2DIbVtPm2VMwUayu8wU4GfBHtOwin4cLWsvT orefalo@dummy.com
```

Should you need to regenerate the key pair, the process is equally user friendly: use `g key -gen`

```
$ git key -gen
Regenerate SSH Key (y/n)? y
Generating SSH keys...
Generating public/private rsa key pair.
/Users/orefalo/.ssh/id_rsa already exists.
Overwrite (y/n)? y
Your identification has been saved in /Users/orefalo/.ssh/id_rsa.
Your public key has been saved in /Users/orefalo/.ssh/id_rsa.pub.
The key fingerprint is:
57:60:84:fa:0e:3b:96:12:15:2e:f3:d5:30:ce:aa:4f orefalo@yahoo.com
The key's randomart image is:
+--[ RSA 2048]----+
|         o+      |
|      . +. .     |
|     . = +  .    |
|    o + + ..     |
|     = +S .      |
|    . + ..       |
|     oE=         |
|    o.= .        |
|     +..         |
+-----------------+
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDYUTgzU9zjsdda9WBEED5bH+SVMq5bYoIxPSzop2IqUBoyyOlRdHt4dy2r/MWiB2eKQOQmPRE7SeawhFWYbCwEdi6BtEe8m4PiZd3OIRV13TlPj54Hi6Q1Ab8emEAH026L4kwef46+j0aJf/7tZzUw/uZW9Wrnf1VN+J1VlWvmYaG9JpPBuatAlTV9rhCeQ2WO39KYWVYJxH1mO0zPEpuTBojji7HYJtlS4OCKgY9mCVBPiUzzLfmrlIhZz+k5rMWv6i4tQtats23qtHEOi9GxJm4+TSGLwM89/C186CJ+8Yx0g/c2DIbVtPm2VMwUayu8wU4GfBHtOwin4cLWsvT orefalo@yahoo.com
```

###Basic commands

Git is often referenced as a content SCM, that freezes the state of a folder. 
So rather than providing a `git add` and `git rm`, **g2** introduces the `freeze` and `unfreeze` commands.

Without arguments, `freeze` literally freezes the state of the workspace into the staging area. The content can later be committed with the `ci` command or unfrozen with `unfreeze`.

Finally the most common git commands `g st` and `g lg` have been enhanced to display a nice colorized outputs.

![image](http://orefalo.github.com/g2/images/lg.png)


###Panic!

It happened to all of us. You try a new command (like a rebase) and things didn't work as expected. "Wait a minutes, what's that blinking led light on the flight panel? Where is the manual?". Suddenly, you feel the necessity to hunt an expert advise. Bad luck he's  either not available, there no-one to help you! "Damn it ! I wish I never run that command!".

Believe it or not, your are Panicking…

Well, here comes `g panic`


`panic` checks out the last good state (HEAD) and removes all files not under source control, leaving a clean workspace to resume from. It's the easiest way to get you back on track and ready to work. No more cood sweats.

###Tracking

A **tracking branch** is a local branch that is connected to a remote branch. When you synchronize on that branch, it automatically pushes and pulls to the remote branch that it is connected with.

**g2** provides a handy command to display and set tracking: `g track`

![image](http://orefalo.github.com/g2/images/track.png)

By default, it displays the tracking table. The command accepts a parameter to set tracking for the working branch. Say you want to track local branch _devel_ with _origin/devel_.  
Switch to the devel branch and type `g track origin/devel`


###Branching

Displaying the list of branches is achieved with the branch `g br` command. Note how it provides details not only about the local and remote branches, but also about the state of these branches when compared to the status on the server.

```
$ g br
  gh-pages
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/gh-pages
  remotes/origin/master
---
gh-pages (ahead 0) | (behind 0) origin/gh-pages
master (ahead 0) | (behind 0) origin/master
```

Give it a parameter and it will create a new branch. **g2** will prompt if you want to create a matching remote branch and setup tracking accordingly.

Use checkout `d co` to switch to that branch.

```
$ g br NEW_branch
(M=6c1fc *1) orefalo@OLIVIERS-IMAC 
$ g br
  NEW_branch
  gh-pages
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/gh-pages
  remotes/origin/master
---
gh-pages (ahead 0) | (behind 0) origin/gh-pages
master (ahead 0) | (behind 0) origin/master
$ g co NEW_branch 
Switched to branch 'NEW_branch'
$ 
```

If you are familiar with git, this is no rocket science. There is however a hidden gem which might save you headaches going forward: **g2** is extremely strict when it comes to switching branches.

You can only switch branch from a stable state. A _stable state_ means: **no modified files, no staged files**. Should you have any changes, **g2** will complain with the following message

    fatal: some files were changed on this branch, either commit <ci>, <wip> or <panic>.



###Working with remotes

Before introducing one of the main **g2** features, let me talk about what **NOT** to do when merging.    
Look at these graphs taken from various projects on github. Note how the branches overlap and how these loops make the graphic extremely difficult to read as the number of commiters increases.

![image](http://orefalo.github.com/g2/images/h2.jpg)
![image](http://orefalo.github.com/g2/images/h3.jpg)

Looks familiar? Wouldn't it be nicer to have straight lines, with segments showing only when feature branches are merged in? Like this…

![image](http://orefalo.github.com/g2/images/good_branching.png)

The above is 30+ developers working together on about 20 active feature branches. Note how the graph is clean an easy to ready.
To get to the above result, **g2** enforces two different merging scenarios, each backed by a different command.

1. Saving the code into its working branch, that's what we do most of the time
2. Merging features from other branches, like merging the changes that your collegues deployed to production.

The matching commands are `g sync` and `g pull`, here is how to use them:

* Use `g sync` to synchronize the current branch. The command doesn't take any parameters because it uses the tracking table to figure the remote/branch. To enforce a clean linear history, the changes are always appended to the end of the branch. Once completed, the changes are sent back to the server.

For the git expert, the command issues a _fetch, a rebase and a push_ with a multitude of validation in between. For instance, it will block if the remote history was force updated; also it won't push a wip commit (see below).

* Use `g pull` when merging contents from a feature branches.


###History changes

**g2** is not permissive when it comes to switching branches, amending or rebasing.
  Unless given the `-f` flag, it will block any attempts untill the workspace is in a "clean" state.
  
You can easily get to a clean state by using `g panic`

###Work in progress

When developing, saving the _work in progress_ is common. How many times do you have to switch branch to troubleshoot another issue?

git _stash_ typically comes to the rescue in that situation. But unless you provide a well detailed comment (which nobody does!), you loose track of which branches the stash applied to.

That's why **g2** introduces `wip` and `unwip`. Two handy commands that you will learn to love. See below and note how a wip commit is created on your current branch.

```
$ g st
## master
MM README.md
M  g2-prompt.sh
(M=000f0 +2 *1) orefalo@OLIVIERS-IMAC 
$ g wip
[master 0dcbfb3] wip
 2 files changed, 31 insertions(+), 13 deletions(-)
(M=0dcbf) orefalo@OLIVIERS-IMAC 
$ g lg
* 0dcbfb3 - (HEAD, master) wip (5 seconds ago) <Olivier Refalo>
* 000f060 - (origin/master, origin/HEAD) fix freeze and wip (5 hours ago) <Olivier Refalo>
* b44487e - adding gui & freeze -m (6 hours ago) <Olivier Refalo>
* 7acd770 - documentation, removed undo (24 hours ago) <Olivier Refalo>
* a248217 - first commit (3 days ago) <Olivier Refalo>
* 5fa2c06 - initial commit (3 days ago) <Olivier Refalo>
$ g unwip
Unstaged changes after reset:
M	README.md
M	g2-prompt.sh
$
```

But how good is a wip commit if it behaves just like any other commit? The point is, it's not a regular commit:

* A wip commit **CANNOT** be **merged, pulled, pushed or synched**. You **cannot commit** on top of it either. It's a real "work in progress" that is meant to be `unwip` at some point.


#List of Commands

### abort

Aborts either a rebase or a merge.
 
### am (?-f)

Amends last commit with contents from the staging area.  
Won't amend if top commit was pushed unless the `-f` flag is given.
 
### br <?branch>

Displays the list of branches, local and remote.  
Can create new branches if given a branch name.
 
### bs / bisect

One of git best tool: `bisect`

### clone (url)

Clones a remote repository, wires to `git clone`
 
### co/checkout (branch)

Switches branch (either local/remote)  
extremely strict - won't let you checkout if you have changes or untracked files
 
### cp/cherry-pick (commit)

Cherry picks a commit from another branch, same as `git cherry-pick`
 
### ci/commit (?params...)

Commits the contents of the staging area. Won't commit on top of a WIP.
 
### df/diff (?params…)

Compares files on the console, wires to `diff`

### dt/difftool (?params…)

Compares files by opening the default diff GUI, wires to `difftool`
 
### freeze (?-m msg) (?file)

Takes all **modified, deleted and untracked** files to the staging area.  
You may also specify which file to stage.

Note that you may also give it the file to stage.
 
### gc

Repository maintenance: prunes obsolete remote branches then a structure check `fsck` followed by a garbage collector `gc`
 
### gp/grep

Searches commits, same as `git grep`
 
### ig (-file)

Adds to gitignore & removes file from source control
 
### init (-folder)

Creates a local repository, wires to `git init`

### key (?-gen)

Displays the public ssh key.  
Give it the `--gen` flag and it will generate a new key.

### mg/merge (?params...) (branch)

Merges branches, same as `git merge`
 
### mt/mergetool (?params...)

Fixes conflicts by opening a visual mergetool
 
### mv

Moves (renames) a file under source control. same as `git mv`
 
### lg/log

By default, displays commit log in a pretty colorized format. Any extra parameter wires to   to `git log`.
 
```
$ git lg
* adbd444 - docs wording improvement pass (3 days ago) <David Greenspan>
* 2edb152 - make tests work in IE 6-10, MobileSafari (3 days ago) <David Greenspan>
*   7a05b13 - Merge pull request #64 from skalb/devel (3 days ago) <matt debergalis>
|\  
| * 9ebb67a - Function passed to Meteor.ui.render must return a string. (3 days ago) <Sameer Kalburgi>
* | e2eadee - Use correct variable name when logging a less error (3 days ago) <Josh McArthur>
* |   32266f5 - Merge pull request #62 from milesmatthias/docupdate (3 days ago) <matt debergalis>
|\ \  
| * | 6d57f14 - Added a note about how to read the docs locally, since it took me a while to figure out how to do it. (8 days ago) <Miles Matthias>
* | | d28ed89 - This is allow any user added script in their header to be able to use the libraries in Meteor. For example including a plugin would have to be always written a
* | |   7d269cd - Merge branch 'http' into devel (3 days ago) <Nick Martin>
|\ \ \  
| * | | cde4a4a - (origin/http) First pass at HTTP docs. (3 days ago) <David Greenspan>
| * | | 0f2673f - initial commit of HTTP package (4 days ago) <David Greenspan>
|/ / /  
* | |   e1a557f - Merge branch 'test-fixups' into devel (4 days ago) <Nick Martin>
|\ \ \  
| * | | d7fe7c9 - have test driver report FAIL if exception anywhere (4 days ago) <David Greenspan>
| * | | e68f9d1 - Remove old busted selenium tests, and move cli tests out of the way. (4 days ago) <Nick Martin>
| * | | b3bdb87 - async_multi: catch exceptions in expect, prevent multi-fail (4 days ago) <David Greenspan>
```

### ls/ls-files (?params…)

List files under source control, wires to `git ls-files`
 
### panic

Lost, confused? Can't figure what state you are in? Use `panic`!

`panic` will checkout the latest stable state (HEAD) and remove all file not under source control, leaving a fresh clean workspace.
 
### pull (?opts) (remote) (branch)

Merges another branch with the current.  
Please use `sync` to synchronize your local branch.

### push (?-f) (?opts) (remote) (branch)

Sends commits to a remote git repository/branch
 
### rb/rebase (?params…) (branch)

Rebases the branch, same as `git rb`
 
### rm (params…)

Removes a file from source control, same as `git rm`
 
### rs/reset (params…)
 
Resets the branch to a different state. same as `git reset`

`$ g rs upstream` 
 
### rt/remote (?params…)

Used to add/remove remotes, same as `git remote`
 
### rv/revert (commit)

Reverts a commit, same as `git revert`
 
### setup

Configures user, key, editor & tools by prompting the user.

### sh/show (?-deep) (?commit)

Shows details about the given commit, defaults to HEAD  
When `-deep` is given, shows the diff.

### st/status (?params…)

Probably the most common command: give details about what changed since last commit.

```
$ git st
```

### sm/submodule (?params…)

Same as `git submodule`

### sync

Synchronizes the current branch with the one of the server.
syncs working branch: fetch, pull-rebase & push
 
### tg/tag

Tags a state, wires to `git tag`
 
### track (?upstream_branch)

Gives information about the tracking table. This table is very important: it tells how local/remote branches are interconnected.

```
$ g track
local: master <--sync--> remote: origin/master
--Remotes---
origin	git@github.com:orefalo/g2.git (fetch)
origin	git@github.com:orefalo/g2.git (push)
```

Should you need to change the tracking, just pass the new destination as a parameter

```
$ g track origin/NEW_branch
local: master <--sync--> remote: origin/NEW_branch
--Remotes---
origin	git@github.com:orefalo/g2.git (fetch)
origin	git@github.com:orefalo/g2.git (push)
```
 
### pull

won't pull on a WIP
won't pull from the tracking branch
Will ask to setup tracking if not set

### push

won't push a WIP
won't push to the tracking branch
Will ask to setup tracking if not set

### unfreeze (?file)

Unfreezes the files from the staging area back into the workspace.

### unwip

Unstacks a WIP from the history into the workspace.

### wip

Easy way to save your WIP (Work In Progress). Stacks all current changes as a commit on the history.

##FAQ

###Why "g2" ?

* `g` is the command, and it obviously comes from **git**
* `2` because most of the actions are two letters long.

###There is no stash ?

No, not for now. With commands `wip` and `unwip`, the stash brings little benefits. You can always cherry pick from one branch to another.

###Is it a new git-flow ?

No, **g2** doesn't enforce any branching policy.  

###What if my favorite command is missing?

Please notify us via the project issue tracker. For the time being, please use `$GIT_EXE`

##Credits

Author: [Olivier Refalo](https://github.com/orefalo)

* Contains a modified version of [git-prompt](http://volnitsky.com/project/git-prompt/) - Leonid Volnitsky
* Contains a modified version of git-completion.bash - Shawn O. Pearce
* [GUM](https://github.com/saintsjd/gum) by saintsjd. Wonder why this project feelt short on delivery.

##License

Distributed under the GNU General Public License, version 2.0.

##TODO
* FIXED: renaming branch fails: g branch -M mv tt

* git branch -a should be ignored, in fact most other - flags should be ignored
* shunit2 the project
* some completions are not properly working - git push origin <TAB> not working ?
* completion, rename __git to avoid conflicts
* g mode
* g as - aliasing
* introduce g2 options - panic exlcudes, count files in prompt




