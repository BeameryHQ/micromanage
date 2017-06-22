#!/usr/bin/env bash

# Colors and visual Configurations
MAGENTA='\033[35m'
RED='\033[31m'
YELLOW='\033[33m'
NC='\033[0m'

export SOURCE_LOCATION=`pwd`

if [ ! -n "$BEAMERY" ]; then
    BEAMERY=~/.beamery
fi

# Check if Beamery micromanage is alreayd installed and ask for am update or re-install
if [ -d "$BEAMERY" ]; then

    printf "${YELLOW}You already have Beamery Micromanage installed.${NC}\n"
    printf "Please select if you wish to ${RED}re-install${NC} or ${MAGENTA}update${NC} Beamery Micromanage [R/U]:" && read -n1 OPTION
    echo ""

    if [[ $OPTION =~ ^[uU]$ ]]; then
        cd "$BEAMERY" && git pull origin master && exit 0
    elif [[ $OPTION =~ ^[rR]$ ]]; then
        rm -rf "$BEAMERY"
    else exit 0
    fi
fi

# Set the environment variables
set_environment_exports() {

    # Setting $BASH to maintain backwards compatibility
    # Getting the user's OS type in order to load the correct installation and configuration scripts
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        if ! grep -q "${1}" "${HOME}/.bashrc" ; then
          echo "Editing ${YELLOW}.bashrc${NC} to load beamery-micromanage on Terminal launch"
          printf "\n%s\n" "${1}" >> "${HOME}/.bashrc"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if ! grep -q "${1}" "${HOME}/.bash_profile" ; then
          echo "Editing ${YELLOW}.bash_profile${NC} to load beamery-micromanage on Terminal launch"
          printf "\n%s\n" "${1}" >> "${HOME}/.bash_profile"
        fi
    fi

    # Check if we have a .zshrc regardless of the os .. and copy that to the zsh source file
    if [[ -f "$HOME/.zshrc" ]]; then
        if ! grep -q "${1}" "${HOME}/.zshrc" ; then
          printf "Noticed that you have ${RED}Zsh${NC} installed. \n(${RED}note: there might be some compatibility issues exporting the beamery tools there as well)${NC}\n"
          read -p "Are you sure you want to proceed exporting beamery tools in your .zshrc ? [Y/N] " -n 1;
          if [[ $REPLY =~ ^[Yy]$ ]]; then
          	echo "Editing ${YELLOW}.zshrc${NC} to load beamery-micromanage on Terminal launch"
          	printf "\n%s\n" "${1}" >> "${HOME}/.zshrc"
          fi
        fi
    fi
}

# Preliminary Checks
hash git >/dev/null 2>&1 || {
    echo "${RED}Error:${NC} git is not installed. We cannot proceed with the installation as we require to pull down files from Github"
    exit 1
}

git clone --depth=1 https://github.com/SeedJobs/beamery-micromanage.git $BEAMERY || {
    printf "${RED}Error:${NC} git clone of beamery-micromanage repo failed\n"
    exit 1
}

# Prompt user to select his type of shell
printf "
Please select what shell helper you need to install the plugins for ${MAGENTA}(bash-it | oh-my-zsh | none (for standalone installation)${NC} ):" && read SHELL_TYPE

install_manually() {


	# We need to makre sure that we have a .beamery folder in home
	[ -d ${HOME}/.beamery ] || mkdir "$HOME/.beamery"

    set_environment_exports "source $HOME/.beamery/beamery/beamery.sh"

    printf "Do not forget now to enable the plugin by sourcing your .bash_profile, .bashrc or .zshrc\n"
}

if [[ "$SHELL_TYPE" == "bash-it" ]]; then

    if [[ -d ${HOME}/.bash_it ]]; then
        ln -sf "$HOME/.beamery/bash-it/beamery.completion.bash" "${HOME}/.bash_it/completion/available"
        ln -sf "$HOME/.beamery/bash-it/beamery.plugin.bash" "${HOME}/.bash_it/plugins/available"
        ln -sf "$HOME/.beamery/bash-it/beamery" "${HOME}/.bash_it/plugins/available"
    else
        printf "We noticed that bash-it is not installed .. installing the plugins manually" && install_manually
    fi

    printf "
    Do not forget now to enable completion and plugins by reloading shell first by resourcing your bash_profile or bashrc and then executing:

    bash-it enable completion beamery
    bash-it enable plugin beamery

    "

elif [[ "$SHELL_TYPE" == "oh-my-zsh" ]]; then
    if [[ -d ${HOME}/.oh-my-zsh ]]; then
        ln -sf "$HOME/.beamery/zsh/beamery" "${HOME}/.oh-my-zsh/plugins/"
    else
        printf "We noticed that oh-my-zh is not installed .. installing the plugins manually" && install_manually
    fi
    printf "
    Do not forget now to enable the plugin by adding beamery to your .zshrc plugins array and then resourcing your bash_profile or bashrc
    "
else
    install_manually
fi
