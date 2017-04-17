#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.oh-my-zsh/plugins/beamery/pluginsInterface.zsh"

# clean_git_local_branches
# Clean any local branches that have been deleted on remote

clean_git_local_branches() {

    delete-branch(){
        for branch in "$@"
        do
          remote=$(git config branch.$branch.remote)
          test -z $remote && remote="origin"
          ref=$(git config branch.$branch.merge)
          test -z $ref && ref="refs/heads/$branch"

          git branch -D $branch
          git branch -d -r $remote/$branch
          git push $remote :$ref
        done
    }

    execute -g $@ "echo""; git branch --merged | egrep -v '(^\*|master|development)'| xargs -I {} delete-branch {}"
    execute -g $@ "echo""; git remote prune origin"

    if [[ `git branch -vv | grep ': gone]'` ]]; then
        printf "\n${YELLOW}Making sure that all 'gone' branches are also removed ..\n\n${NC}"
        execute -g $@ "git fetch -p && for branch in `git branch -vv | grep ': gone]' | gawk '{print $1}'`; do git branch -D $branch; done"
    fi
}
