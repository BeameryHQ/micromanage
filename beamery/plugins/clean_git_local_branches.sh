# Load the main plugins "interface"
source "${HOME}/.beamery/beamery/pluginsInterface.sh"

# clean_git_local_branches
# Clean any local branches that have been deleted on remote

clean_git_local_branches() {

    execute -g $@ "echo""; git branch --merged | egrep -v '(^\*|master|development)'| xargs -I {} git delete-branch {}"
    execute -g $@ "echo""; git remote prune origin"

    printf "\n${YELLOW}Making sure that all 'gone' branches are also removed ..\n\n${NC}"
    execute -g $@ "git fetch -p && for branch in `git branch -vv | grep ': gone]' | gawk '{print $1}'`; do git branch -D $branch; done"
}
