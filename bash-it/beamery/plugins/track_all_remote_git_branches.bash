#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.bash_it/plugins/available/beamery/pluginsInterface.bash"

# track_all_remote_git_branches
# Track all remote branches that are not being tracked locally
# This is useful when we want to clean out local branches and need to fetch all remote branches

track_all_remote_git_branches() {
    execute -g $@ "git branch -r | grep -v '\->' | while read remote; do git branch --track ${remote#origin/} $remote > /dev/null; done;"
    echo "--> All remote branches tracked"
}
