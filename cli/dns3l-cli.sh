#!/bin/bash

SHORT_HELP="DNS3L CLI helper"
LONG_HELP="Available commands:
 list      | List certs issued by DNS3L ACME CA(s)
 get       | List cert details from DNS3L ACME CA(s)
 key       | Get cert key PEM from DNS3L ACME CA(s)
 crt       | Get cert PEM from DNS3L ACME CA(s)
 chain     | Get cert chain PEM from DNS3L ACME CA(s)
 root      | Get cert root PEM from DNS3L ACME CA(s)
 rootchain | Get cert rootchain PEM from DNS3L ACME CA(s)
 fullchain | Get cert fullchain PEM from DNS3L ACME CA(s)
 claim     | Obtain cert from DNS3L ACME CA(s)
 delete    | Delete cert issued by DNS3L ACME CA(s)"

# ARG_POSITIONAL_SINGLE([CMD],[command])
# ARG_TYPE_GROUP_SET([cmd],[CMD],[CMD],[list,get,key,crt,chain,root,rootchain,fullchain,claim,delete])
# ARG_POSITIONAL_SINGLE([FQDN],[FQDN as certificate name])
# ARG_POSITIONAL_INF([SAN],[optional list of SAN])
# ARG_OPTIONAL_SINGLE([config],[f],[config file],[~/.${NAME}.conf])
# ARG_OPTIONAL_REPEATED([ca],[c],[CA to use],[les])
# ARG_TYPE_GROUP_SET([ca],[CA],[ca],[les,le,d3ls,d3l,any])
# ARG_OPTIONAL_SINGLE([dns],[i],[AutoDNS (A)RR to create])
# ARG_OPTIONAL_BOOLEAN([wildcard],[w],[create a wildcard])
# ARG_OPTIONAL_BOOLEAN([windows],[m],[running on Windows])
# ARG_OPTIONAL_BOOLEAN([skiptls],[s],[skip TLS validation])
# ARG_OPTIONAL_BOOLEAN([anonymous],[a],[no auth, no bearer])
# ARG_DEFAULTS_POS([])
# ARG_HELP([$SHORT_HELP],[$LONG_HELP])
# ARG_VERSION([echo $VERSION])
# ARG_VERBOSE([d])
# ARGBASH_SET_INDENT([  ])
# ARG_POSITIONAL_DOUBLEDASH([])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
  local _ret="${2:-1}"
  test "${_PRINT_HELP:-no}" = yes && print_help >&2
  echo "$1" >&2
  exit "${_ret}"
}

# validators

cmd()
{
	local _allowed=("list" "get" "key" "crt" "chain" "root" "rootchain" "fullchain" "claim" "delete") _seeking="$1"
	for element in "${_allowed[@]}"
	do
		test "$element" = "$_seeking" && echo "$element" && return 0
	done
	die "Value '$_seeking' (of argument '$2') doesn't match the list of allowed values: 'list', 'get', 'key', 'crt', 'chain', 'root', 'rootchain', 'fullchain', 'claim' and 'delete'" 4
}


ca()
{
	local _allowed=("les" "le" "d3ls" "d3l" "any") _seeking="$1"
	for element in "${_allowed[@]}"
	do
		test "$element" = "$_seeking" && echo "$element" && return 0
	done
	die "Value '$_seeking' (of argument '$2') doesn't match the list of allowed values: 'les', 'le', 'd3ls', 'd3l' and 'any'" 4
}


begins_with_short_option()
{
  local first_option all_short_options='fciwmsahvd'
  first_option="${1:0:1}"
  test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_cmd=
_arg_fqdn=
_arg_san=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_config="~/.${NAME}.conf"
_arg_ca=(les)
_arg_dns=
_arg_wildcard="off"
_arg_windows="off"
_arg_skiptls="off"
_arg_anonymous="off"
_arg_verbose=0


print_help()
{
  printf '%s\n' "$SHORT_HELP"
  printf 'Usage: %s [-f|--config <arg>] [-c|--ca <CA>] [-i|--dns <arg>] [-w|--(no-)wildcard] [-m|--(no-)windows] [-s|--(no-)skiptls] [-a|--(no-)anonymous] [-h|--help] [-v|--version] [-d|--verbose] [--] <CMD> <FQDN> [<SAN-1>] ... [<SAN-n>] ...\n' "$0"
  printf '\t%s\n' "<CMD>: command. Can be one of: 'list', 'get', 'key', 'crt', 'chain', 'root', 'rootchain', 'fullchain', 'claim' and 'delete'"
  printf '\t%s\n' "<FQDN>: FQDN as certificate name"
  printf '\t%s\n' "<SAN>: optional list of SAN"
  printf '\t%s\n' "-f, --config: config file (default: '~/.${NAME}.conf')"
  printf '\t%s' "-c, --ca: CA to use. Can be one of: 'les', 'le', 'd3ls', 'd3l' and 'any' (default array elements:"
  printf " '%s'" les
  printf ')\n'
  printf '\t%s\n' "-i, --dns: AutoDNS (A)RR to create (no default)"
  printf '\t%s\n' "-w, --wildcard, --no-wildcard: create a wildcard (off by default)"
  printf '\t%s\n' "-m, --windows, --no-windows: running on Windows (off by default)"
  printf '\t%s\n' "-s, --skiptls, --no-skiptls: skip TLS validation (off by default)"
  printf '\t%s\n' "-a, --anonymous, --no-anonymous: no auth, no bearer (off by default)"
  printf '\t%s\n' "-h, --help: Prints help"
  printf '\t%s\n' "-v, --version: Prints version"
  printf '\t%s\n' "-d, --verbose: Set verbose output (can be specified multiple times to increase the effect)"
  printf '\n%s\n' "$LONG_HELP"
}


parse_commandline()
{
  _positionals_count=0
  while test $# -gt 0
  do
    _key="$1"
    if test "$_key" = '--'
    then
      shift
      test $# -gt 0 || break
      _positionals+=("$@")
      _positionals_count=$((_positionals_count + $#))
      shift $(($# - 1))
      _last_positional="$1"
      break
    fi
    case "$_key" in
      -f|--config)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_config="$2"
        shift
        ;;
      --config=*)
        _arg_config="${_key##--config=}"
        ;;
      -f*)
        _arg_config="${_key##-f}"
        ;;
      -c|--ca)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_ca+=("$(ca "$2" "ca")") || exit 1
        shift
        ;;
      --ca=*)
        _arg_ca+=("$(ca "${_key##--ca=}" "ca")") || exit 1
        ;;
      -c*)
        _arg_ca+=("$(ca "${_key##-c}" "ca")") || exit 1
        ;;
      -i|--dns)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_dns="$2"
        shift
        ;;
      --dns=*)
        _arg_dns="${_key##--dns=}"
        ;;
      -i*)
        _arg_dns="${_key##-i}"
        ;;
      -w|--no-wildcard|--wildcard)
        _arg_wildcard="on"
        test "${1:0:5}" = "--no-" && _arg_wildcard="off"
        ;;
      -w*)
        _arg_wildcard="on"
        _next="${_key##-w}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          { begins_with_short_option "$_next" && shift && set -- "-w" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -m|--no-windows|--windows)
        _arg_windows="on"
        test "${1:0:5}" = "--no-" && _arg_windows="off"
        ;;
      -m*)
        _arg_windows="on"
        _next="${_key##-m}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          { begins_with_short_option "$_next" && shift && set -- "-m" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -s|--no-skiptls|--skiptls)
        _arg_skiptls="on"
        test "${1:0:5}" = "--no-" && _arg_skiptls="off"
        ;;
      -s*)
        _arg_skiptls="on"
        _next="${_key##-s}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          { begins_with_short_option "$_next" && shift && set -- "-s" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -a|--no-anonymous|--anonymous)
        _arg_anonymous="on"
        test "${1:0:5}" = "--no-" && _arg_anonymous="off"
        ;;
      -a*)
        _arg_anonymous="on"
        _next="${_key##-a}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          { begins_with_short_option "$_next" && shift && set -- "-a" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -h|--help)
        print_help
        exit 0
        ;;
      -h*)
        print_help
        exit 0
        ;;
      -v|--version)
        echo $VERSION
        exit 0
        ;;
      -v*)
        echo $VERSION
        exit 0
        ;;
      -d|--verbose)
        _arg_verbose=$((_arg_verbose + 1))
        ;;
      -d*)
        _arg_verbose=$((_arg_verbose + 1))
        _next="${_key##-d}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          { begins_with_short_option "$_next" && shift && set -- "-d" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      *)
        _last_positional="$1"
        _positionals+=("$_last_positional")
        _positionals_count=$((_positionals_count + 1))
        ;;
    esac
    shift
  done
}


handle_passed_args_count()
{
  local _required_args_string="'CMD' and 'FQDN'"
  test "${_positionals_count}" -ge 2 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require at least 2 (namely: $_required_args_string), but got only ${_positionals_count}." 1
}


assign_positional_args()
{
  local _positional_name _shift_for=$1
  _positional_names="_arg_cmd _arg_fqdn "
  _our_args=$((${#_positionals[@]} - 2))
  for ((ii = 0; ii < _our_args; ii++))
  do
    _positional_names="$_positional_names _arg_san[$((ii + 0))]"
  done

  shift "$_shift_for"
  for _positional_name in ${_positional_names}
  do
    test $# -gt 0 || break
    eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
    shift
  done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash
# Validation of values
_arg_cmd="$(cmd "$_arg_cmd" "CMD")" || exit 1


### END OF CODE GENERATED BY Argbash (sortof) ### ])
