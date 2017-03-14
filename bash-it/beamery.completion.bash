_beamery_comp()
{
    local cur prev opts prevprev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    chose_opt="${COMP_WORDS[1]}"
    file_type="${COMP_WORDS[2]}"
    opts="help execute"
    if [ -d "${HOME}/.bash_it/plugins/available/beamery/plugins" ]; then
        for config_file in ${HOME}/.bash_it/plugins/available/beamery/plugins/*.bash
        do
          if [ -e "${config_file}" ]; then
            opts+=" `basename $config_file .bash`"
          fi
        done
    fi
    case "${chose_opt}" in
        help)
            local help_args="$(echo "${opts}" | cut -d " " -f2-)"
            COMPREPLY=( $(compgen -W "${help_args}" -- ${cur}) )
            return 0
            ;;
    esac
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

complete -F _beamery_comp beamery
