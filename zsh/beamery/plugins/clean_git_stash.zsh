# Load the main plugins "interface"
source "${HOME}/.oh-my-zsh/plugins/beamery/pluginsInterface.zsh"

# clean_git_stash
# Clean any stashed commits

clean_git_stash() {

    printf "${RED}Please note that this will clear any stashes you have saved${NC}\n"
    read -p "Are you sure you want to proceed ? [Y/N] " -n 1;

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        execute -g $@ "git stash clear && echo '--> done'"
    fi
    echo "";
}
