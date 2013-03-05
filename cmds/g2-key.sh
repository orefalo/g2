#!/bin/bash
# displays or generates ssh keys

source "$G2_HOME/cmds/color.sh"

displayKey() {
 echo -e -n "${yellowf}"
 cat "$HOME/.ssh/id_rsa.pub"
 echo -e -n "${reset}"
}

gen() {
    echo_info "Generating SSH keys..."
    emailinput=$("$GIT_EXE" config --global --get user.email)
    ssh-keygen -t rsa -P "" -C "$emailinput" -f "$HOME/.ssh/id_rsa"
    displayKey
}


if [[ $1 != -gen ]]; then
    [[ ! -f $HOME/.ssh/id_rsa.pub ]] && fatal "SSH key not found at ${boldon}$HOME/.ssh/id_rsa.pub${boldoff}" || displayKey
else
    if [[ -f $HOME/.ssh/id_rsa.pub ]]; then
        read -p "Regenerate SSH Key (y/n)? " -n 1 -r
        [[ $REPLY == [yY]* ]] && (echo; gen) || echo
    else
        gen
    fi
fi
