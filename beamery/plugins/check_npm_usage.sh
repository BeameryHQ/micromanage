#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.bash_it/plugins/available/beamery/pluginsInterface.bash"

# check_npm_usage
# Check the places a certain npm package is used across all the repos

check_npm_usage() {

  # Save and keep track of the parent directory to revert back to after operations are done
  PARENT_FOLDER=`pwd`

  find . -maxdepth 1 -type d \( ! -name . \) | while read -r SUBFOLDER; do [[ -f "$PARENT_FOLDER/$SUBFOLDER/package.json" ]] && cat "$PARENT_FOLDER/$SUBFOLDER/package.json" | grep -sw $1 && echo "$SUBFOLDER"; done;

}
