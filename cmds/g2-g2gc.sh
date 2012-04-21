#!/bin/bash
#

"$GIT_EXE" fetch --all -p && "$GIT_EXE" fsck && "$GIT_EXE" reflog expire --expire=now --all && "$GIT_EXE" gc --aggressive --prune=now
