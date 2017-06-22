#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.oh-my-zsh/plugins/beamery/pluginsInterface.zsh"

# check_node_package_usage
# Check the places a certain npm package is used across all the repos

check_node_package_usage() {

  find . -maxdepth 1 -type d \( ! -name . \) | while read -r SUBFOLDER; do [[ -f "`pwd`/$SUBFOLDER/package.json" ]] && cat "`pwd`/$SUBFOLDER/package.json" | grep -sw "\"$1\":" && echo "$SUBFOLDER"; done;

}
