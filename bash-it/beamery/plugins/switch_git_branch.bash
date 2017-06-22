#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.bash_it/plugins/available/beamery/pluginsInterface.bash"

# switch_git_branch
# Switch the branches of .git repos into a specific branch
# The command accepts an optional argument which is the new branch to checkout
# If no argument was passed then the command will default and switch all repos to master
    # Default paramteres: git checkout master

switch_git_branch() {

    BRANCH=${1:-master}

	if [[ $@ == *'-s'* ]]; then
		echo "This function is not designed to work in single folder mode .. please revert to good old fashioned commands"
	else
	    printf "${RED}Please note that this will stash any changes made in the repos and flip the current branch${NC}\n"
	    read -p "Are you sure you want to proceed? [Y/N] " -n 1;
	    if [[ $REPLY =~ ^[Yy]$ ]]; then
	        if ! [[ $BRANCH =~ ^(master|development)$ ]]; then
	            printf "\nYou are switching to a non-default branch ... fetching first\n"
				execute -g "echo''; git fetch; git branch | grep -w $BRANCH > /dev/null && git stash && git checkout $BRANCH || echo 'This branch does not exist in this repo'; echo''"
	        else
	        	execute -g "echo''; git branch | grep -w $BRANCH > /dev/null && git stash && git checkout $BRANCH || echo 'This branch does not exist in this repo'; echo''"
	        fi
	    fi;
	fi;
}
