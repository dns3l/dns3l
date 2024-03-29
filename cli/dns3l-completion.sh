#!/bin/bash

# Put this file to /etc/bash_completion.d/dns3l-completion.sh_ENDL_()# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info

_dns3l_completion_sh ()
{
  local cur prev opts base
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  all_long_opts="--config --ca --dns --wildcard --windows --skiptls --anonymous --help --version --verbose "
  all_short_opts="-f -c -i -w -m -s -a -h -v -d "
  case "$prev" in
    --ca|-c)
      COMPREPLY=( $(compgen -W "les le d3ls d3l any" -- "${cur}") )
      return 0
      ;;
    --config|-f|--dns|-i)
      COMPREPLY=( $(compgen -o bashdefault -o default -- "${cur}") )
      return 0
      ;;
    *)
      case "$cur" in
        --*)
          COMPREPLY=( $(compgen -W "${all_long_opts}" -- "${cur}") )
          return 0
          ;;
        -*)
          COMPREPLY=( $(compgen -W "${all_short_opts}" -- "${cur}") )
          return 0
          ;;
        *)
          COMPREPLY=( $(compgen -o bashdefault -o default -- "${cur}") )
          return 0
          ;;
      esac
  esac

}
complete -F _dns3l_completion_sh dns3l-completion.sh
### END OF CODE GENERATED BY Argbash (sortof) ### ])
