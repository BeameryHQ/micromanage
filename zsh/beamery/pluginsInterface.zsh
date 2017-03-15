#!/usr/bin/env bash

# Colors and visual Configurations
MAGENTA='\033[35m'
RED='\033[31m'
YELLOW='\033[33m'
NC='\033[0m'

# Some helper functions to check if a certain command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# Executes a passed command in each repository. This is the main core function as it will iterate on all the subfolders in a given
# folder and execute the command passed as an argument in each sub-folder
# The function accepts three flag options:
    # -h: execute in hidden folders as well
    # -n: executes only in folders where valid node.js code is found
    # -g: executes only in folders where a valid git repo is found

execute() {

    # This is the main function that will execute the passed function based on the option parameters
    # The paramteres are:
        # IS_NODE_FOLDER: Which will execute the function if a package.json file was found -> valid node.js code
        # IS_GIT_FOLDER: Which will execute the function if a .git/config file was found -> valid git repo

    _execute() {
        if [[ $IS_NODE_FOLDER = 1 ]]; then
            if [ -f "package.json" ]; then
                [ $IS_SHOW_FOLDER_TYPE = 1 ] && printf "\nExecuting command as folder is identified to contain valid ${YELLOW}Node.js${NC} code\n"
                eval "$@"
            fi
        elif [[ $IS_GIT_FOLDER = 1 ]]; then
            if [ -f ".git/config" ]; then
                [ $IS_SHOW_FOLDER_TYPE = 1 ] && printf "\nExecuting command as folder is identified to be a valid ${YELLOW}git${NC} repository\n"
                eval "$@"
            fi
        else
            eval "$@"
        fi
    }

    # Reset in case getopts has been used previously in the shell
    # The advantages of getopts are:
        # It's portable, and will work in e.g. dash.
        # It can handle things like -vf filename in the expected Unix way, automatically.
    # For more information on getopts: http://wiki.bash-hackers.org/howto/getopts_tutorial

    OPTIND=1

    # Initialize our own variables:

    IS_NODE_FOLDER=0
    IS_GIT_FOLDER=0
    IS_HIDDEN_FOLDER=0
    IS_SINGLE_FOLDER=0
    IS_SHOW_FOLDER_TYPE=0

    while getopts "shngp" opt; do
        case "$opt" in
        s)  IS_SINGLE_FOLDER=1
            ;;
        p)  IS_SHOW_FOLDER_TYPE=1
            ;;
        h)  IS_HIDDEN_FOLDER=1
            ;;
        n)  IS_NODE_FOLDER=1
            ;;
        g)  IS_GIT_FOLDER=1
            ;;
        esac
    done

    shift $((OPTIND-1))
    [ "$1" = "--" ] && shift

    # Save and keep track of the parent directory to revert back to after operations are done
    PARENT_FOLDER=`pwd`

    # Check if the user wishes to execute the function only at the current folder
    if [[ $IS_SINGLE_FOLDER = 1 ]]; then
        _execute $@;
    else
        # Check if the hidden flag is turned on with the -h param
        if [[ $IS_HIDDEN_FOLDER = 1 ]]; then
            find . -maxdepth 1 -type d \( ! -name . \) | while read -r SUBFOLDER; do cd "$PARENT_FOLDER/$SUBFOLDER" && printf "\nRepository: ${MAGENTA}$SUBFOLDER${NC} " && _execute $@; done;
            echo;
        else
            find . -maxdepth 1 -type d \( ! -name ".*" \) | while read -r SUBFOLDER; do cd "$PARENT_FOLDER/$SUBFOLDER" && printf "\nRepository: ${MAGENTA}$SUBFOLDER${NC} " && _execute $@; done;
            echo;
        fi
    fi

    # Go back to parent directory after finishing
    cd $PARENT_FOLDER
}
