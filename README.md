[![Build Status][travis-badge]][travis-link]
[![Slack Room][slack-badge]][slack-link]

![image](http://orefalo.github.com/g2/images/G2.jpg)

#Introduction

I see it every day, beginners have a hard time picking up **git**. Aside from the DSCM concepts, the command line is not easy: it is aimed at people who know git.. advanced nerds, not beginners.

This project is an attempt to make the git command line a friendly place: it eases the learning process by providing guidance and high level commands.

##Benefits

* **g2** saves time by providing high level commands.
* **g2** is generally safer than git as it prompts before destructive actions.
* **g2** helps setup git: sshkeys, username, email and tools.
* **g2** provides two letter acronyms for most commands.
* **g2** eases the merge process by introducing three new verbs:**sync**, **abort** and **continue**.
* **g2** provides a reduced set of commands which give guidance on what to do next.
* **g2** enhances command line experience auto-completion and a smart prompt.
* **g2** warns when a branch history was changed on the server (forced pushed).
* **g2** checks the freshness of the branch prior to merging and warns accordingly.
* **g2** enforces a clean linear history by introducing new commands.
* **g2** requires a **clean state** before rebasing, checking out, branching or merging.
* **g2** provides guidance when it cannot perform an operation.
* **g2** brings a number of friendly commands such as : **panic**, **track**, **freeze**, **wip**.
* **g2** eases branch creation.
* **g2** is just easier at undoing things, see the **undo** command

###What G2 is not

* A replacement for **git**. Rather, g2 is a layer on top of git
* A magic way to learn GIT. It will only help by providing guidance.

#Installation

**PRE-REQUISITES**: 

* **g2** is a layer on top of git, If you are doing a manual install, a recent version of git must be pre-installed.
* Please backup your favorite ~/.gitconfig as g2 with recreate it from scratch.
* G2 runs **bash** and **fishshell**.

###MacOS/Linux

Only the fishshell version is maintained.
With [fishshell](https://fishshell.com/) and [fisherman](http://fisherman.sh/) previously installed, run

    fisher g2

#How to use

The project overrides the `g` and `git` commands. Taken without parameters it displays the following output.

```
$ g
G2 Usage:
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
	gc - garbage collects: run fsck & gc
	gp - grep
	gui - launches the GUI
	ig <file> - adds to gitignore & removes from source control
	init <folder> - init a repository
	key <?-gen> - displays/generates your ssh public key
	mg <?params...> <branch> - merge
	mt <?params...> - fixes conflicts by opening a visual merge-tool
	mv - move (rename) a file
	lg - displays commit log
	ls <?params...> - list files under source control
	panic - gets you back on HEAD, cleans all un-tracked files
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
	sm <?params...> - sub-module
	ss <?params> - stash
	st <?params...> - status
	sync <?upstream> - syncs working branch: fetch, rebase & push
	tg - tag
	track <?upstream_branch> - shows/set tracking
	undo <file>|commit <hash>|merge - reverts changes
	wip/unwip - save/restore work in progress to branch
```

On top of providing two letters acronyms for most git commands, **g2** has interesting features which enhance command line experience.

## Prompt & Completion

Let's start with the "sexy" one: the g2 prompt. 

![image](http://orefalo.github.com/g2/images/g2-prompt.jpg)

The prompt shows:

* The current branch name and the hash of the last commit. **M** is used as a substitute for "master"
* File counts: staged, changed and un-tracked filed.
* Obviously username and host.
* And finally the path, which smartly truncates at 40 characters.
* The prompt colors will adjust depending of the state of the repository: clean, modified, conflict resolution... etc
* Not visible on this screen shot is the optional error code should a shell command fail.

Note: file counters can be expensive with large repositories. You may turn off the feature by running `g setup` and setting "Count files in the bash prompt? (true):" to **false**.

##Setup

So here you go, you downloaded git for the first time and I bet you are stuck on the ssh key generation. git is so lame and user unfriendly.

alright, with **g2** this is how it works:

1. type `g setup` and answer the questions.
2. **that's it**! 

![image](http://orefalo.github.com/g2/images/setup.png)

At anytime in the future, you may display your ssh public key with: `g key`. copy/paste it into github. You are done.

![image](http://orefalo.github.com/g2/images/key.jpg)

Should you need to regenerate the key pair, the process is equally user friendly: use `g key -gen`

![image](http://orefalo.github.com/g2/images/key_gen.jpg)

##Freeze, Unfreeze & Commit

I have some files I want to stage. Do I want `git add .`, `git add -u`, or `git add -A`? Which does what again? Confused. What about staging deletions?

**g2** comes with simplicity in mind, rather the using some of the commands above, **g2** introduces `freeze` and `unfreeze`.

![image](http://orefalo.github.com/g2/images/freeze.jpg)

Without arguments, `g freeze` literally freezes the state of the workspace into the staging area. It's convenient, one command to stage all the changes: additions and deletions. If I need to point the file to stage, I can use `g freeze <path>`.

Once changes are frozen, they can be committed with: `g ci -m "commit description"`
There is also a handy one way command `g freeze -m "msg"`, that skips the staging area and commits directly.

Ooops, I staged a change that I do not want to commit: I would then use `g unfreeze <path>` to get the file(s) out of the way.

Try the [CheatSheet](http://orefalo.github.com/g2/) it helps visualize what commands do.

##Undoing changes

Since we introduced **unfreeze** in the previous section, let's cover undoing: Standard git commands are very confusing when it comes to undoing things. It requires using the **reset** command which has a bunch of strange parameters that make writes to the git index. In fact, in order to undo changes properly, the reset command requires the user to have a clear understanding of the guts of the git index. This should not be the case for a common command, like undo.

So here comes **g2** with the following undo scenarios:

* `g undo commit` - undo the last commit, put changes back into the staging area.
* `g undo merge` - reverts all commits up to the state before the last merge.
* `g undo myfile.txt` - reverts any changes made to myfile.txt.

##Reviewing the History

Working with beginners, I found that an easy way to keep them focused is to provide _visuals_. Now this is not the github network graph, but it's close enough to get them focused. Type `g lg` and enjoy the enhanced colorized commit log output.

![image](http://orefalo.github.com/g2/images/lg.png)

Learn to read that tree, it's important: it holds the commit history for the current branch.

##Panic!

It happened to all of us. You try a new command (like a rebase) and things don't work as expected: git complains on every commit attempt, the prompt shows a weird status. Suddenly, you feel the urgency to hunt an expert advise: you start hunting the closest git-master: bad luck he's not around! In fact there is no-one to help you! "Damn it ! I wish I never run that command!", you start pulling your hairs and screaming "CVS was so much bettttttter!"

Well, you are panicking... and we built a command especially for you: `g panic`

Use `panic` when you feel like getting help from your git master. It checks out the last known good state (HEAD) and removes all files not under source control, leaving a clean workspace to resume from. It's the easiest way to get you back on track and ready to work. No more cold sweats and your git-master can rest.

##Branching

Displaying the list of branches is achieved with the branch command: `g br`. Note how it provides details not only about the local and remote branches, but also about the state of these branches when compared to the status on the server.

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

Given a parameter, the command creates a new branch. **g2** walks you though the steps that will typically take git 3 to 4 commands.

![image](http://orefalo.github.com/g2/images/newbranch.jpg)

Use checkout `g co NEW_branch` to switch to that branch.

```
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

If you are familiar with git, this is no rocket science. There is however a hidden gem which might save you headaches going forward: **g2** is extremely strict when it comes to switching branches: it only works from a stable state.

By _stable state_ I mean: **no modified files, no staged files**. Should you have any changes, **g2** will complain with the following message:

    fatal: some files were changed on this branch, either commit <ci>, <wip> or <panic>.

##Merging,continue & abort

**g2** enforces a simpler merge flow by introducing commands `abort` & `continue`.

![image](http://orefalo.github.com/g2/images/conflicts.jpg)


So what commands can get you into **merge mode**? Well the ones that merge contents: `sync`, `pull`, `rebase`, `merge` and `cherry-pick` to name just a few. Merging with git is a revolution compared to other source control systems, most of the time it happens automatically. But in a few instances, you will need to resolve **conflicts** manually.


When this happens, g2 will stop the merge flow. Let me emphasize what that means:

* If you are merging, a conflicts will stop before the final commit.
* If you are rebasing or syncing, a conflicts will stop on the current replay step.

You may resolve conflicts by issuing a `g mt` (mt=mergetool). The default visual mergetool will show up and let you resolve each conflicting file manually. Typically, you will see your file on one side, the file you are merging with on the other and the common ancestor. The common ancestor is here to quickly identify what happened in the file: you can quickly pick additions and removals.

Once conflict resolution is completed, the merge process needs to be resumed manually.  
Now, If you are a git expert, you know that there are actually 3 commands to resume form the 2 scenarios above. git makes it so confusing, doesn't it?

With **g2** we simplified the process: no matter what flow you are in, there is only one command to resume: `g continue`. That's it!

Finally I should probably mention `g abort` that cancels an ongoing merge/rebase and reverts back to the state prior to the merge attempt.


##Tracking

The whole concept of _tracking_ is broken in git. It's not so much the feature, it's the way it is typically explained. All beginners wonder "What the hell is a **tracking branch** and how is it different from a regular branch?"

Backup… let's start from the beginning, the **g2** way this time:

Please type the following command: `g track`, you should see something as such:

![image](http://orefalo.github.com/g2/images/track.png)

That's the tracking table. the first sections shows how each local branch is _linked_ to its **upstream** remote/branch. In other words, what you see is the mapping between your local branches and the ones on the server(s). clear?

Ok... and now what? 

Well tracking is used across several commands in **g2**, the most common one is `g sync` which you will learn in the next section. But you can also issue a `g reset upstream` or a `g diff upstream`. Even when you create a branch, **g2** reads to current tracking to figure where to create the remote branch.

Note that you may use `g track remote/branch` to set the mapping. For instance, say we are on branch test and we issue a `g track origin/mytest`. the local branch test will now synchronize with the server origin/mytest. 


##Synching

Before introducing one of the main **g2** features, let me talk about what **NOT** to do when merging with git.  
    
Please have a glance at these graphs taken from various projects on github. Note how the branches overlap and how these loops make the graphic extremely difficult to read as the number of committers increases.

![image](http://orefalo.github.com/g2/images/h2.jpg)
![image](http://orefalo.github.com/g2/images/h3.jpg)

Looks familiar? Wouldn't it be nicer to have straight lines, with segments showing only when feature branches are merged in? As such...

![image](http://orefalo.github.com/g2/images/good_branching.png)

The above graph is 30+ developers working together on about 20 active feature branches. Note how the graph is clean an easy to read. 

In order to achieve this result, **g2** enforces two different merging scenarios, each backed by a different command:

1. Saving the code in the working branch, that's what we do most of the time
2. Merging features from other branches, like merging the latest changes from production.

The matching commands are `g sync` and `g pull`, here is how to use them:

![image](http://orefalo.github.com/g2/images/sync.jpg)

* Use `g sync` to synchronize the current branch. The command doesn't take any parameters because it uses the tracking table to figure the remote/branch. To enforce a clean linear history, the changes are always appended to the end of the branch. Once completed, the changes are sent back to the server.

For the git expert, the command issues a _fetch, a rebase and a push_ with a multitude of validations in between. For instance, it will block if the remote history was force updated; also it won't push a wip commit (see below).

* Use `g pull` when merging contents from a feature branches.

Note: **g2** also supports `g sync upstream` which only fetch and rebase, handy with read-only clones ;-)

##Saving the Work In Progress (WIP)

Saving the _work in progress_ is a common task: Typically, git _stash_ comes to the rescue. The issue with stashing is that you typically loose track of which branch it was created from. Stashing is indeed a short term solution.

**g2** introduces `wip` and `unwip`. Two handy commands that you will learn to love. Unlike stashing, wip commits the work in progress as a regular commit.

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

But unlike commits, wip commits **CANNOT** be **merged, pushed or synched**. You **cannot commit** on top of them either.  
In other words, a wip commit in meant to stay at the tip of the branch until you are ready to `unwip` and resume your development.

## Upstream

For convenience, several commands have been enhanced to accept the "upstream" keyword. As discussed earlier, the upstream is the on the server that syncs with your local branch. To see tracking setting, just enter `g track`

* g rs upstream - resets the current branch to the state of the upstream (read the state of the branch on the server)
* g merge upstream - merge local branch from the contents from the upstream
* g sync upstream - pull contents from the server, rebase but **DON'T** push

##List of Commands

Please refer to the [cheatsheet](http://orefalo.github.com/g2/).

#FAQ

###Why "g2"?

* `g` is the command and it obviously comes from **git**
* `2` because most of the actions are two letters long.

###Is G2 a new git-flow?

No, **g2** doesn't enforce any branching policy.  

###Is G2 compatible with git?

* From a source control standpoint, yes **g2** is interoperable with git.
* From a command line parameters standpoint, definitely NOT. **g2** grammar is simplified and hence doesn't support all the options available in git.

###Why is G2 reinstalled on every launch?

To ensure the git configuration is in a stable, known state. Beginers can screw pretty bad when editing their gitconfig file.

###What if my favorite command is missing?

Please notify us via the project issue tracker. For the time being, please use `$GIT_EXE` to run the real git command.

#Credits

Author: [Olivier Refalo](https://github.com/orefalo)

* Contains a modified version of [git-prompt](http://volnitsky.com/project/git-prompt/) - Leonid Volnitsky
* Contains a modified version of git-completion.bash - Shawn O. Pearce
* [GUM](https://github.com/saintsjd/gum) by saintsjd. Wonder why this project felt short on delivery.
* Andrew Peterson/ NDP Software for their cool interactive Cheat sheet
* The maintainers behind msysgit who made git on windows all possible

##License

Distributed under the GNU General Public License, version 2.0.

##TODO
* g remote: when resetting origin, prompt user to override existing
* g track origin/blabla - if origin/blabla not setup, prompt user to fetch from origin
* g br newbranch (from a branch with no remote) -> does prompt to create the branch
* g2-co: check if branch is local then checkout branch, if remote checkout -b branch origin/branch
* g track origin/newbranch, if branch doesn't exist - create it!
      
## FIXED / DONE
* g ignore alias for ig
* g undo needs more validations
* g2 is an official homebrew formula
* g server - will start a local git server
* optimized branch identification logic
* git-prompt: detect rebase, rather than displaying detached-branch
* Validate that we are in a git repo before any action is run
* Homebrew fomula is now live
* allow g co <hash>
* Many commands are now colorized
* Added tips of the day
* fix issue with --set-upstream being deprecated
* fix warning when running: g track <remote/branch>
* `g dt` was failing when comparing with other branches. reverted.
* non-issue: g2-windows needs a new build - on windows: get freeze .gitignore fails with path issue
* non-issue: g2-windows needs a new build - on windows: get version fails wth git path issue \program
* g sync won't update the local branch
* issue with bash 3.2
* upgrade g2-msys to 1.7.11
* fix little issue with undo,freeze,dt,ig
* g rv wasn't working
* g dt upstream
* g rb upstream
* g df upstream
* g mg upstream
* g2 completion - merged with upstream git 1.7.11 completion
* completion, rename __git to avoid conflicts -> cancelled: probably better this way
* g version
* add doc about, g sync upstream + completion
* g sync upstream
* sm - not working
* g undo merge = reset --hard ORIG_HEAD
* g ss/stash
* g undo file
* g undo commit
* g undo commit -f

[travis-link]: https://travis-ci.org/orefalo/g2
[travis-badge]: https://img.shields.io/travis/orefalo/g2.svg
[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[fisherman]: https://github.com/fisherman/fisherman
