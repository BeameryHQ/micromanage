#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.bash_it/plugins/available/beamery/pluginsInterface.bash"

# clean_git_local_branches
# Clean any local branches that have been deleted on remote

clean_git_local_branches() {

    # Check if gawk is installed which is not by default in mac systems
    if ! type gawk &> /dev/null ; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            printf "The required package ${YELLOW}gawk${NC} was not found .. installing now\n"
            brew install gawk
        fi
    fi

    execute -g $@ "echo""; git fetch --all && git remote prune origin && git gc --prune=now; echo''";

    if [[ `git branch -vv | grep ': gone]'` ]]; then
        printf "\n${YELLOW}Making sure that all 'gone' branches are also removed ..\n\n${NC}"
        execute -g $@ "git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -d"
    fi

}
