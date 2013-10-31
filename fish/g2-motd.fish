
function __g2_greeting
    if status -i

        set -l tips \
         "<g sync> adds your changes to the tip of the branch and synchronizes with the servers both ways." \
         "<g freeze> is a handy command to freeze all the changes in one shot." \
         "g2 saves time by providing high level commands." \
         "g2 is safer than git as it prompts before destructive actions." \
         "run <g setup> to configure git." \
         "g2 provides two letter acronyms for most commands." \
         "g2 eases the merge process by introducing <g continue> and <g abort>." \
         "g2 purposely provides a reduced set of commands." \
         "g2 enhances command line experience with auto-completion <TAB-key> and a smart prompt." \
         "g2 warns when the branch history was changed on the server (forced pushed)." \
         "g2 checks the branch freshness prior to merging and warns accordingly." \
         "g2 enforces a clean linear history by introducing new commands." \
         "g2 requires a clean state before rebasing, checking out, branching or merging." \
         "g2 provides guidance when it cannot perform an operation." \
         "g2 brings a number of friendly commands such as : panic, sync, freeze, wip." \
         "g2 eases branch creation. try it <g br branchName>." \
         "Need to display your ssh public key? try <g key>." \
         "g2 is just easier at undoing things: try <g undo commit> or <g undo merge>." \
         "When lost, <g panic> is the easiest way to get back on track." \
         "Use <g track> to review how local/remote branches are setup." \
         "Remember, you may always access the native git command using <command git>."\
         "Unlike git, g2 actions only apply to the current branch."

        set_color --bold white
        echo -n "Tip of the day: "
        set_color normal
        set -l idx (math 1+(random)\*(count $tips)/32766)
        echo $tips[$idx];

    end
end

function fish_greeting
    __g2_greeting
end