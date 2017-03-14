beamery() {

    if [ -d "${HOME}/.oh-my-zsh/plugins/beamery/plugins" ]; then
        for config_file in ${HOME}/.oh-my-zsh/plugins/beamery/plugins/*.zsh
        do
          if [ -e "${config_file}" ]; then
            source $config_file
          fi
        done
    fi

    # Check if the second param passed is a call to the help .. if so launch the help if not .. execute the command
    if [[ $1 == "help" ]]; then
        printf "We cannot execute help without specifying the command you wish you show help for e.g., ${YELLOW}beamery help audit_git_branches${NC}\nAlternatively, you can execute ${YELLOW}beamery --help${NC} or ${YELLOW}beamery -h${NC} for general help\n"
    elif [[ $1 == "--help" || $1 == "-h" ]]; then
        help beamery
    elif [[ $2 = "--help" ]]; then
        help $1
    else
        # Execute the command/function passed as an argument
        $@
    fi

    help() {
        if [[ $1 = "beamery" ]]; then
            printf "\n${YELLOW}Beamery Microservices Helpers${NC}\nBeamery Micro-services Helpers are shell helper functions that will automate and facilitate manipulating micro-services repos and in general any multiple folders in a certain directory\n"
            printf "\n${YELLOW}Supported Plugins:${NC}\n"
            for config_file in ${HOME}/.oh-my-zsh/plugins/beamery/plugins/*.zsh
            do
                printf "\n${YELLOW} `echo $(basename $config_file) | sed "s/.*\///" | sed "s/\..*//"` ${NC}"
                printf "\n" && grep '#' "${config_file}" | cut -c 2- | tail -n +3
            done
            printf "\n${YELLOW}execute${NC}\nExecute a passed function on all the repos or a single repo if  provided the -s flag\n"
        elif [[ $1 = "execute" ]]; then
            echo "Executes a passed command in each repository"
        else
            printf "\n" && grep '#' "$HOME/.oh-my-zsh/plugins/beamery/plugins/${1}.zsh" | cut -c 2- | tail -n +3
        fi
    }

}

_beamery_comp ()
{
    local -a arg _help
    local expl
    typeset -A opt_args

    _help=('--help[Display a description about the command]')

    arg=()

    if [ -d "${HOME}/.oh-my-zsh/plugins/beamery/plugins" ]; then
        for config_file in ${HOME}/.oh-my-zsh/plugins/beamery/plugins/*.zsh
        do
          if [ -e "${config_file}" ]; then
            EXCERPT=$(grep '#' "${config_file}" | cut -c 2- | tail -n +3 | head -n 1)
            arg+=("`basename $config_file .zsh`: $EXCERPT")
          fi
        done
        arg+=("execute: Execute a passed function on all the repos or a single repo if provided the -s flag")
    fi

    _arguments \
    $_help \
    '*:: :->subcmds' && return 0

    if (( CURRENT == 1 )); then
        _describe -t commands "beamery subcommand" arg
        return
    fi
    case "$words[1]" in
        *)
        _arguments \
        $_help \
        ;;
    esac
}

compdef _beamery_comp beamery
