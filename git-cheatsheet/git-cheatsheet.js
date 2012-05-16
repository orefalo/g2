
var commands = [

{
	left: "workspace",
	right: "workspace",
	direction: "status",
	cmd: "setup",
	docs: 'Setup the git echo system, prompts for username, email, ssh keys, diff tool, merge tool and various other preferences.'
},
{
	left: "workspace",
	right: "workspace",
	direction: "status",
	cmd: "key <-gen>",
	docs: 'With no parameters, displays your ssh public key. With <-gen> generates your ssh identity.'
},
{
	left: "workspace",
	right: "index",
	direction: "status",
	cmd: "init",
	docs: "Initializes a local repository"
},
{
	left: "workspace",
	right: "remote_repo",
	direction: "dn",
	cmd: "clone <repo>",
	docs: "Download the repository specified by <repo> and checkout HEAD of the master branch."
},
{
	left: "workspace",
	right: "index",
	direction: "status",
	cmd: "st/status",
	docs: "Displays the list of differences with the local repository. This includes modified files, new and deleted files. But also files with are not under source control."
},
{
	left: "workspace",
	right: "index",
	direction: "status",
	cmd: "df/diff",
	docs: "Displays the differences not added to the staging area."
},
{
	left: "workspace",
	right: "local_repo",
	direction: "status",
	cmd: "ls/ls-files",
	docs: "Lists files under source control. typical flags are --stage --modified --unmerged"
},
{
	left: "local_repo",
	right: "local_repo",
	direction: "status",
	cmd: "sh/show <commit>",
	docs: "Shows the contents of the given commit. by default HEAD." + "Use -deep to see a diff"
},

{
	left: "workspace",
	right: "index",
	direction: "up",
	cmd: "freeze",
	docs: "Freeze all files in the repository to the staging area, thus staging that content for inclusion in the next commit. Also accept a specific path as parameter"
},

{
	left: "workspace",
	right: "local_repo",
	direction: "up",
	cmd: "freeze -m 'msg'",
	docs: "Commit all files changed since your last commit, including deleted and un-tracked files. "
},

{
	left: "workspace",
	right: "index",
	direction: "dn",
	cmd: "unfreeze",
	docs: "Moves the contents of the staging area back into the workspace. accepts a specific path as parameter."
},

{
	left: "workspace",
	right: "local_repo",
	direction: "up",
	cmd: "wip",
	docs: "Perfect for saving the work in progress, saves the state of the workspace into the staging area as a WIP commit, wip(work in progress) commits can't be merged, pulled, pushed or synced."
},
{
	left: "workspace",
	right: "local_repo",
	direction: "dn",
	cmd: "unwip",
	docs: "Unstacks the wip commit at the tip of the branch into the workspace."
},
{
	left: "workspace",
	right: "index",
	direction: "up",
	cmd: "mv <file...>",
	docs: "Rename a file in the workspace and the staging area."
},
{
	left: "workspace",
	right: "index",
	direction: "up",
	cmd: "rm <file...>",
	docs: "Remove file in the workspace and the staging area."
},
{
	left: "workspace",
	right: "index",
	direction: "up",
	cmd: "ig <file... or dir...>",
	docs: "Ignore file going forward, updates the .gitignore and remove file from the workspace and the staging area."
},
{
	left: "workspace",
	right: "local_repo",
	direction: "dn",
	cmd: "undo <file...>",
	docs: "Reverts the file in the workspace, overwriting any local changes."
},

{
	left: "index",
	right: "local_repo",
	direction: "dn",
	cmd: "undo commit",
	docs: "Undo the last commit, leaving changes in the the staging area. Only applies if commit is local, -f to force undo."
},

{
	left: "workspace",
	right: "local_repo",
	direction: "dn",
	cmd: "co/checkout <branch or commit>",
	docs: "Switches branches. Replaces files in the workspace accordingly. Can also checkout a specific state if given the commit hash."
},

{
	left: "workspace",
	right: "local_repo",
	direction: "dn",
	cmd: "mg/merge <branch_name>",
	docs: "Merge changes from <branch_name> into current branch. Use --no-commit to leave changes uncommitted."
},

{
	left: "workspace",
	right: "local_repo",
	direction: "dn",
	cmd: "rb/rebase <remote/branch>",
	docs: "Reverts all commits since the current branch diverged from <remote/branch>, and then re-applies them one-by-one on top of changes from the HEAD of <remote/branch>."
},

{
	left: "workspace",
	right: "local_repo",
	direction: "dn",
	cmd: "cp/cherry-pick <commit>",
	docs: "Applies the given commit on top of the current branch."
},

{
	left: "workspace",
	right: "local_repo",
	direction: "dn",
	cmd: "rv/revert <commit>",
	docs: "Reverse specified <commit> and commits the result. " + "This requires your working tree to be clean (no modifications from the HEAD commit)."
},

{
	left: "index",
	right: "local_repo",
	direction: "status",
	cmd: "df/diff --cached",
	docs: "View the changes you staged vs the latest commit. Can pass a <commit> to see changes relative to it."
},
{
	left: "index",
	right: "local_repo",
	direction: "up",
	cmd: "ci/commit -m 'msg'",
	docs: "Stores the current contents of the staging area in a new commit along with a log message from the user describing the changes."
},
{
	left: "index",
	right: "local_repo",
	direction: "up",
	cmd: "am",
	docs: 'Amends the last commit with the current staging changes. Only local commits can be amended, -f to force amend.'
},

{
	left: "local_repo",
	right: "local_repo",
	direction: "status",
	cmd: "lg/log",
	docs: 'By default, shows a graph of your recent commits/merges. With a parameter, show recent commits, most recent on top. Options: --decorate    with branch and tag names on appropriate commits' + '--stat        with stats (files changed, insertions, and deletions)' + '--author=foo  only by a certain author' + '--after="MMM DD YYYY" ex. ("Jun 20 2008") only commits after a certain date' + '--before="MMM DD YYYY" only commits that occur before a certain date' + '--merge       only the commits involved in the current merge conflicts'
},
{
	left: "local_repo",
	right: "local_repo",
	direction: "status",
	cmd: "df/diff <commit>..<commit>",
	docs: "View the changes between two arbitrary commits"
},
{
	left: "local_repo",
	right: "remote_repo",
	direction: "status",
	cmd: "br/branch",
	docs: "List all existing branches local or remote along with details about their ahead/behind state."
},
{
	left: "local_repo",
	right: "local_repo",
	direction: "status",
	cmd: "br/branch -d <b_name>",
	docs: "Delete an specified branch. Use -D to force."
},
{
	left: "local_repo",
	right: "local_repo",
	direction: "status",
	cmd: "br/branch -m <b_name>",
	docs: "Renames the specified branch. Use -M to force."
},
{
	left: 'local_repo',
	right: 'local_repo',
	direction: 'status',
	cmd: 'track',
	docs: "Displays the tracking setup. Each local branch is enumerated with its matching tracking remote. Also displays the remote URLs"
},
{
	left: 'local_repo',
	right: 'remote_repo',
	direction: 'status',
	cmd: 'track <remote/branch>',
	docs: 'Setup tracking between the current branch and the given remote branch.'
},

{
	left: "workspace",
	right: "remote_repo",
	direction: "dn",
	cmd: "pull <remote> <branch>",
	docs: "Merges changes from a feature branch into the current branch. Runs a fetch to get the latest updates from the server followed by a merge & commit. May stop if conflicts are detected, in which case <mt> & <continue> should be used. Note that you cannot pull the default tracking branch. Please use <sync> for that purpose."
},
{
	left: "local_repo",
	right: "remote_repo",
	direction: "dn",
	cmd: "fetch <remote>",
	docs: "Download objects and refs from another repository."
},
{
	left: "local_repo",
	right: "remote_repo",
	direction: "up",
	cmd: "sync",
	docs: 'Ensures your local branch and the sever branch are synchronized.' +
		  ' Auto-appends changes to the tip of the branch to enforce a clean linear history.' +
		  ' Internally, runs a fetch, a rebase and finally a push.'
},
{
	left: "local_repo",
	right: "remote_repo",
	direction: "up",
	cmd: "push <remote> <branch>",
	docs: "Push current branch to remote repository, under name <branch>. Note that you can't push to the tracking branch, use <sync> for that purpose. -f to force push"
},

{
	left: "remote_repo",
	right: "remote_repo",
	direction: "status",
	cmd: "push <remote> :<branch>",
	docs: "Remove a remote branch. Be careful!"
},
{
	left: "workspace",
	right: "workspace",
	direction: "status",
	cmd: "mt/mergetool",
	docs: 'Opens each conflicting file with the visual merge tool. Once completed, use <continue> or <abort>.'
},
{
	left: "workspace",
	right: "workspace",
	direction: "status",
	cmd: "continue",
	docs: 'Resumes a conflicts resolution (merge/rebase).'
},
{
	left: "workspace",
	right: "workspace",
	direction: "status",
	cmd: "abort",
	docs: 'Abort an ongoing merge or rebase. '
},
{
	left: "workspace",
	right: "local_repo",
	direction: "dn",
	cmd: "panic",
	docs: 'Aborts any ongoing operation and gets you back to your last known commit, cleans up the working tree by recursively removing files that are not under version control.'
},
{
	left: "workspace",
	right: "local_repo",
	direction: "dn",
	cmd: "abort",
	docs: 'Aborts any ongoing merge or rebase operation and gets you back to the original state.'
},
{
	left: "workspace",
	right: "remote_repo",
	direction: "dn",
	cmd: "rs/reset upstream",
	docs: "Resets the branch (and the workspace) to the state of the branch on the server. the command accepts other powerful parameters."
},

{
	left: "workspace",
	right: "workspace",
	direction: "status",
	cmd: "gc",
	docs: 'Cleans up the repository and remotes. Prunes, fscks and garbage collects the repository from loose objects.'
},

{
	left: "stash",
	right: "workspace",
	direction: "dn",
	cmd: "ss/stash save <name>",
	docs: 'Stashes current changes. Can provide a name.'
},
{
	left: "stash",
	right: "workspace",
	direction: "status",
	cmd: "ss/stash list",
	docs: "Show all stashed changes"
},
{
	left: "stash",
	right: "workspace",
	direction: "up",
	cmd: "ss/stash apply <name>",
	docs: "Move changes from the specified stash into the workspace. The latest stash is the default."
},
{
	left: "stash",
	right: "workspace",
	direction: "up",
	cmd: "ss/stash pop",
	docs: 'Applies the changes from the last (or specified) stash and then removes the given stash.'
}

];



function esc(s) {
	return s.replace(/</g, 'zyx').replace(/>/g, '</em>').replace(/zyx/g, '<em>');
}

$(function() {

	jQuery('.loc').append('<div class="bar" />');

	var left_offset = $('#commands').offset().left;
	for (i = 0; i < commands.length; i++) {
		var c = commands[i];
		var left = $("#" + c.left + " div.bar").offset().left - left_offset;
		var right = $("#" + c.right + " div.bar").offset().left - left_offset;
		var width = right - left;
		if (width < 1) {
			left -= 90
			width = 200;
		} else {
			left += 10;
			width -= 20;
		}
		var $e = $("<div>" + esc(c.cmd) + "<div class='arrow' /></div>").css('margin-left', left + 'px').css('width', width + 'px').addClass(c.left).addClass(c.right).addClass(c.direction);
		$('#commands').append($e);

		if (c.docs) {
			$e.attr('data-docs', esc(c.docs));
		}
	}

	$('[data-docs],.loc').live('click', function() {
		var $info = $('#info');
		$info.find('.cmd,.doc').empty();

		var cmd = $(this).html();
		if ($(this).parent('#commands').length > 0) {
			cmd = 'g ' + cmd;
		}
		$('<span>').html(cmd).appendTo($info.find('.cmd'));
		var d = $(this).attr('data-docs') || '';
		$('<span>').html(d).appendTo($info.find('.doc'));
		_gaq.push(['_trackEvent', 'git-cheatsheet', 'mouseover', cmd, null]);
	});



	function selectLoc(id) {
		$('body').removeClass('stash workspace index local_repo remote_repo').addClass(id);
		$('#diagram .loc.current').removeClass('current');
		$('#' + id).addClass('current');
		window.location.href = '#loc=' + id + ';';
		_gaq.push(['_trackEvent', 'git-cheatsheet', 'select-loc', id, null]);
	}

	$("#diagram .loc").
	click(
	function() {
		selectLoc(this.id);
	}).
	hover(function() {
		$(this).addClass('hovered');
	},
	function() {
		$(this).removeClass('hovered');
	});

	var oldBodyClass = '';
	$('div.stash,div.workspace,div.index,div.local_repo,div.remote_repo').
	click(
	function() {

	}).
	hover(
	function() {
		oldBodyClass = $('body').attr('class');
	},
	function() {
		$('body').attr('class', oldBodyClass);
	});

	// Highlight given location specified by hash.
	var hash = window.location.hash;
	if (hash && hash.length > 1) {
		var m = hash.match(/loc=([^;]*);/);
		if (m && m.length == 2) {
			selectLoc(m[1]);
		}
	}

});
