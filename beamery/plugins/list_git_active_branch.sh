#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.beamery/beamery/pluginsInterface.sh"

# list_git_active_branch
# List the current branches on the repos
# This is useful to know which branches are flipped on which repos

list_git_active_branch() {
    execute -g $@ printf "'${YELLOW}'  &&  git branch | grep '^\*' | cut -d' ' -f2 && printf '${NC}'"
}
