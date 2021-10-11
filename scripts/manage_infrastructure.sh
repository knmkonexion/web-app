#!/bin/bash

set -e

##
## Infrastructure Management Helper
## Motiviation: because I don't like typing the same thing over-and-over...
## Version: 0.0.1-dev
## Maintainers: Kasey Weirich
## License: none, use at your own free will
## ---------------------------------
##
## Usage: manage_infrastructure.sh [arguments]
##
##
## Arguments:
##   -h, --help         Displays the help message.
##   plan <env>         Plans all resources for the given environment
##   provision <env>    Provisions all resources for the given environment
##   destroy <env>      Destroys all resources for the given environment
##   clean_cache <env>  Cleans Terragrunt/Terraform cache for the given environment (also used in each plan/provision step)
##
## Example:
##   ./manage_infrastructure.sh plan development
##   ./manage_infrastructure.sh provision development
##   ./manage_infrastructure.sh destroy development
##

usage() {
  [ "$*" ] && echo "$0: $*"
  sed -n '/^##/,/^$/s/^## \{0,1\}//p' "$0"
  exit 2
} 2>/dev/null

clean_cache() {
  rm -Rf ../infrastructure/live/"${1}"/*/.terragrunt-cache 
  rm -Rf ../infrastructure/live/"${1}"/*/.terraform.lock.hcl
}

plan() {
  echo '-----------------------'
  echo "Planning $1"
  echo '-----------------------'
  clean_cache "$1"
  cd ../infrastructure/live/"${1}" && terragrunt run-all plan
}

provision() {
  echo '-----------------------'
  echo "Povisioning $1"
  echo '-----------------------'
  clean_cache "$1"
  cd ../infrastructure/live/"${1}" && terragrunt run-all plan && terragrunt run-all apply --terragrunt-non-interactive
}

destroy() {
  echo '-----------------------'
  echo "Destroying $1"
  echo '-----------------------'
  cd ../infrastructure/live/"${1}" && terragrunt run-all destroy --terragrunt-non-interactive
}

main() {
while [ "$#" -gt 0 ]; do
  case "$1" in
    (-h|--help) usage 2>&1;;
    (plan) plan "$2";;
    (provision) provision "$2";;
    (destroy) destroy "$2";;
    (clean_cache) clean_cache "$2";;
    (*) "Invalid argument";;
  esac
  exit 0;
done
}

if [ "$#" -eq 0 ]; then 
  usage && exit 1
elif [[ $(basename "$PWD") == 'scripts' ]]; then
  main "$@"
else
  echo '[WARNING] - you must be in the scripts directory for this script to work'
  usage
fi