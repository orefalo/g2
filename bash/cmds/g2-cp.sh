#!/bin/bash
#
# Cherry picking, but forbids anything on top of wip commit

"$GIT_EXE" rev-parse || exit 1

"$GIT_EXE" g2iswip || exit 1
"$GIT_EXE" cherry-pick "$@"