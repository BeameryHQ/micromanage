# Load the main plugins "interface"
source "${HOME}/.bash_it/plugins/available/beamery/pluginsInterface.bash"

# clean_git_branches
# Total cleaning on branches by first performing deletion of remote branches that have been merged into master
# Second step will be to execute deletio of local branches that are not on remote/merged into master

clean_git_branches() {
    clean_git_remote_branches $1
    clean_git_local_branches $1
}
