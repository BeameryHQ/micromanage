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

    # Check if gawk is installed which is not by default in mac systems
    if ! type git-delete-branch &> /dev/null ; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            printf "The required package ${YELLOW}git-extras${NC} was not found .. installing now\n"
            sudo brew install git-extras
        fi
        if [[ "$OSTYPE" == "linux-gnu" ]]; then
            printf "The required package ${YELLOW}git-extras${NC} was not found .. installing now\n"
            sudo apt-get install git-extras
        fi
    else
        execute -g $@ "echo""; git branch --merged | egrep -v '(^\*|master|development)'| xargs -I {} git delete-branch {}"
        execute -g $@ "echo""; git remote prune origin"

        if [[ `git branch -vv | grep ': gone]'` ]]; then
            printf "\n${YELLOW}Making sure that all 'gone' branches are also removed ..\n\n${NC}"
            execute -g $@ "git fetch -p && for branch in `git branch -vv | grep ': gone]' | gawk '{print $1}'`; do git branch -D $branch; done"
        fi
    fi

}
