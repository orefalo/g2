#!/bin/bash
#

[[ $("$GIT_EXE" g2isrebasing) = "true" ]] && "$GIT_EXE" rebase --continue 2> /dev/null