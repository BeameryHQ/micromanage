#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.beamery/beamery/pluginsInterface.sh"

# check_npm_usage
# Check the places a certain npm package is used across all the repos

check_npm_usage() {

  # execute -n grep -sw $1 ./package.json
  find . -maxdepth 1 -type d \( ! -name . \) | while read -r SUBFOLDER; do [[ -f "`pwd`/$SUBFOLDER/package.json" ]] && cat "`pwd`/$SUBFOLDER/package.json" | grep -sw "\"$1\":" && echo "$SUBFOLDER"; done;

}
