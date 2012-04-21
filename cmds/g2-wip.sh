#!/bin/bash
#

if [[ $("$GIT_EXE" g2iswip) = "true" ]]; then
    echo "info: amending previous wip commit..."
    "$GIT_EXE" g2am
else
    "$GIT_EXE" freeze -m wip
fi
