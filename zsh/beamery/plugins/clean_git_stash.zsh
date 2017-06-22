#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.oh-my-zsh/plugins/beamery/pluginsInterface.zsh"

# Clean any stashed commits

clean_git_stash() {

    printf "${RED}Please note that this will clear any stashes you have saved${NC}\n"
    read -q "REPLY?Are you sure you want to proceed ? [Y/N] ";

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        execute -g $@ "echo ''; git stash clear && echo '--> done'"
    fi
    echo "";
}
