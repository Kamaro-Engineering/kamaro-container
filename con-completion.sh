_con_opts()
{
  local curr_arg available_containers
  curr_arg=${COMP_WORDS[COMP_CWORD]}

  if ! [ "$(groups | grep -F 'docker')" ] && [[ "$(whoami)" != "root" ]]; then
    COMPREPLY=( $(compgen -W "" -- $curr_arg ) )
    return
  fi
  available_containers="$(docker container ls -a --format='table {{.Names}}' | tail -n +2)"
  if [[ "$COMP_CWORD" == 1 ]]; then
    COMPREPLY=( $(compgen -W "$available_containers" -- $curr_arg ) )
  else
    COMPREPLY=( $(compgen -c -- $curr_arg ) )
  fi
}

complete -F _con_opts con
