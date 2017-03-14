## Beamery Micromanage - A Micro-services Helpers Framework

At [Beameary](http://beamery.com) we follow [Microservices Architecture](https://en.wikipedia.org/wiki/Microservices) which has various advantages from it being easier to scale, deploy independent services to elimination of any long-term commitment to a technology stack. However, Microservices Architecture also has its fair number of disadvantages as testing and inter-services communication become harder.

We currently have a good 50+ git repository. Developing features affect very often more than one of these repos. Changing branches, syncing and development is hard as you have to keep flipping between multiple terminal tabs to make sure all the repos are in order. Beamery Micro-services Helpers are shell helper functions that will automate and facilitate manipulating micro-services repos and in general any multiple folders in a certain directory.

![demo](http://g.recordit.co/zyhTtLDI56.gif)

> supports bash (version >= 4.0) and zsh (>= 5.0)

These helper functions are configured out of the box to work [bash-it](https://github.com/Bash-it/bash-it) plugins framework for bash and [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) plugins framework for zsh.

## Installation

You can install the helpers using the installation script by executing `. install.sh` .. the script will then prompt to select the type of shell you are using, check for the existence of any shell helper and then install the relevant helpers accordingly.

### One-liner installation

You can install this pugin via the command-line with either curl or wget:

#### via `curl`

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/SeedJobs/beamery-micromanage/master/install.sh)"
```

#### via `wget`

```bash
sh -c "$(wget https://raw.githubusercontent.com/SeedJobs/beamery-micromanage/master/install.sh -O -)"
```

The manual installation details for these are:

#### bash-it

bash-it separates plugins, aliases and completion functions into three separate folders. To install the completion you will need to copy `bash-it/beamery.completion.bash` to `$BASH_IT/completion/available` which is usually is in `$HOME/.bash_it/completion/available`.

To Install the plugin, you need to copy both the main plugin in `bash-it/beamery.plugin.bash` and the plugins folder in `bash-it/beamery/` to `$BASH_IT/plugins/available` which is usually is in `$HOME/.bash_it/plugins/available`

Activating now the plugins and completion is done via executing both `bash-it enable completion beamery` and `bash-it enable plugin beamery` in the terminal and then reloading the sherll either by `reload` which is a bash-it alias or by sourcing `.bash_profile` or `.bashrc` depending on your OSX by executing `source $HOME/.bash_profile; source $HOME/.bashrc`

#### oh-my-zsh

oh-my-zsh have all their plugin in the plugins folder inside the installation directory of `oh-my-zsh` which is usually in `$HOMR/.oh-my-zsh/plugins`.

Installing oh-my-zsh beamery plugin is done by copying beamery folder in `zsh/beamery/` to oh-my-zsh plugins directory and then activating the plugin by editing your `$HOME/.zshrc` and adding `beamery` to the list of plugins so that you have something similar to:

```bash
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(brew git npm nvm node osx pyenv python scala sublime tmux beamery)
```

#### Manual

If you do not use any shell halpers but still want to take advantage of these helper functions, you can still install them manually. Basically all what you need to do is source the main entry file which is in `manual/beamery.sh` from your `.bash_profile` or `.bashrc` depending on your OSX. Basically, i create a new folder in my `$HOME` and i call it `.beamery` so thats its hidden, and i copy the contents of `manual` inside so that i have:

```
├── .beamery
    ├── beamery.sh
    ├── plugins
    └── pluginsInterface.sh
```
then i add the line `source $HOME/.beamery/beamery.sh` inside my `$HOME/.bash_profile` as i am on OSX but can be inside your `.bashrc` as well. Simply, reload by re-sourcing these files and you are good to go.

## What does it do ?

Currently the helper functions configured are:

 - **audit_git_branches**: List all the branches of a .git repository sorted by date creation
 - **clean_git_branches**: Total cleaning on branches by first performing deletion of remote branches that have been merged into master
 - **clean_git_local_branches**: Clean any local branches that have been deleted on remote
 - **clean_git_remote_branches**: Clean remote branches that have been merged into master and delete them from remotes as well
 - **clean_git_stash**: Clean any stashed commits
 - **clean_npm_modules**: Clean unused NPM modules from each repo
 - **generate_npm_report**: Generate NPM report using the npm-check module to inspect the state of our npm modules
 - **link_node_modules**: Remove all node_modules from all the repos and run zelda to link and download all
 - **list_git_active_branch**: List the current branches on the repos
 - **switch_git_branch**: Switch the branches of .git repos into a specific branch
 - **switch_git_branch_and_update**: Switch the branches of .git repos into a specific branch and update from the latest remote origin
 - **track_all_remote_git_branches**: Track all remote branches that are not being tracked locally
 - **update_git_branch**: Update .git branches from the latest remote origin

> For the all the plugins, any supported flag (-g, -n, -h, -s) that are described below will be ported as well and executed with each function. So for example, if you wish to only execute `clean_npm_modules` inside of any folder you can then execute `beamery clean_npm_modules -s`

For git functions, there are default params set for `pull` and `push` which are `origin` for your remote and `master` for local branch. However, these can be easily overridden by passing the desired names to the appropriate function call. Example:

```bash
beamery switch_git_branch_and_update
# This will call the sub functions for example like `git checkout master` and `git pull origin master`
beamery switch_git_branch_and_update development
# This will call the sub functions for example like `git checkout development` and `git pull origin development`
beamery switch_git_branch_and_update development upstream
# This will call the sub functions for example like `git checkout development` and `git pull upstream development`
```

### Autocomplete

Autocompletion is enabled by default and supports both zsh and bash. For zsh, hitting tab immediately after `beamery` will show the list of supported plugins to execute. Hitting a tab afterwards will add the `--help` flag which will show the help docs for that plugin.

There is a dedicated `help` function that will be triggered by `beamery help PLUGIN_NAME` that will show the help docs for each plugin.

> help can be also triggered by appending the `--help` flag after each call

### Shell Helpers Architecture

The most common prerequisite before executing any "helper" function is to be able to execute that function on every repository you have. Adding new plugins is very easy, you just need to create a new file with the desired function name inside the `plugins` folder. Then, you need to make sure that the file will have:

 - `source "${HOME}/PATH_TO_INTERFACE/pluginsInterface.sh"` this is done to load the main plugins "interface"
 - Properly have comments in the file as these will be extracted to show the help docs
 - Executing the code in every folder is done by calling the main `execute` function and passing the set of commands you need to execute to that function.

 #### What is `execute` ?

 Execute takes a folder type as an argument. This tells the function to verify the folder contents before executing the function. For example, you only want to execute a `git fetch` if the folder processed is a valid git repo. The supported flags passed are:

  - **-s**: only execute the function selected in the current folder
  - **-g**: git folders examined by the existence of a valid `.git` folder inside
  - **-n**: node folders examined by the existence of a valid `package.json` folder inside
  - **-h**: include as well hidden folders as they are not parsed by default
  - **-p**: suppress the debug sentence when executing inside folders

```bash

    # Check if the hidden flag is turned on with the -h param
    if [[ $IS_HIDDEN_FOLDER = 1 ]]; then
        find . -maxdepth 1 -type d \( ! -name . \) | while read -r SUBFOLDER; do cd "$PARENT_FOLDER/$SUBFOLDER" && printf "\nRepository: ${MAGENTA}$SUBFOLDER${NC}\n" && _execute $@; done;
    else
        find . -maxdepth 1 -type d \( ! -name ".*" \) | while read -r SUBFOLDER; do cd "$PARENT_FOLDER/$SUBFOLDER" && printf "\nRepository: ${MAGENTA}$SUBFOLDER${NC}\n" && _execute $@; done;
    fi

    function _execute() {
        if [[ $IS_NODE_FOLDER = 1 ]]; then
            if [ -f "package.json" ]; then
                printf "\nExecuting command as folder is identified to contain valid ${YELLOW}Node.js${NC} code\n"
                eval $@
            fi
        elif [[ $IS_GIT_FOLDER = 1 ]]; then
            if [ -f ".git/config" ]; then
                printf "\nExecuting command as folder is identified to be a valid ${YELLOW}git${NC} repository\n"
                eval $@
            fi
        else
            eval "$@"
        fi
    }
```

### Extending with your own plugins

Adding new plugins is fairly straighforward. You just need to create a new plugin in the `plugins/` folder. The guidelines for creating plugins are:

 - The plugin filename will be the same as the command you wish to be executed
 - Each plugin should source the `pluginInterface` e.g., `source "${HOME}/.beamery/beamery/pluginsInterface.sh"`. You can refer to existing plugins to know the path for the interface depending on your shell implementation
 - Documentation and help for each plugin will be extracted directly from the comments in the plugin file. **Note**: The first line of the comment should be the plugin name
 - To handle the `-s` flag, you might need to implement special logic if you want to block the execution of that function. For example, check the `update_git_branch` plugin

