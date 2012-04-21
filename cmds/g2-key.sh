#!/bin/bash
#

gen() {
    echo "Generating SSH keys..."
    emailinput=$("$GIT_EXE" config --global --get user.email)
    ssh-keygen -t rsa -P "" -C "$emailinput" -f "$HOME/.ssh/id_rsa"
    cat "$HOME/.ssh/id_rsa.pub"
}


if [[ $1 != -gen ]]; then
    [[ ! -f $HOME/.ssh/id_rsa.pub ]] && echo "fatal: SSH key not found: $HOME/.ssh/id_rsa.pub" || cat "$HOME/.ssh/id_rsa.pub"
else
    if [[ -f $HOME/.ssh/id_rsa.pub ]]; then
        read -p "Regenerate SSH Key (y/n)? " -n 1 -r
        [[ $REPLY == [yY]* ]] && (echo; gen) || echo
    else
        gen
    fi
fi
