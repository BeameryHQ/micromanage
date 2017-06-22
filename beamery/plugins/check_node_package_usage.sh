#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.beamery/beamery/pluginsInterface.sh"

# check_node_package_usage
# Check the places a certain npm package is used across all the repos

check_node_package_usage() {

  execute -n "grep -sw $1 ./package.json >/dev/null && printf '\e[1A\e[40C' && grep -sw '\"$1\":' ./package.json || printf '\e[1A\e[K'"

}



