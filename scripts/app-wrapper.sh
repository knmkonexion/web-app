#!/bin/bash

set -e

##
## [Application Wrapper Script]
## Motiviation: To demonstrate how monitoring and alerting works, ensue chaos and restore calm!
## Version: 0.0.1-dev
## Maintainers: Kasey Weirich
## ---------------------------------
##
## Usage: app-wrapper.sh [arguments]
##
##
## Arguments:
##   -h, --help                          Displays the help message.
##   chaos <deployment_name>             Scales down a deployment to demonstrate a little bit of chaos (for monitoring and alerting demonstration) 
##   calm <deployment_name> <replicas>   Scales a deployment up by number of replicas, restoring things to a calm state
##

usage() {
  [ "$*" ] && echo "$0: $*"
  sed -n '/^##/,/^$/s/^## \{0,1\}//p' "$0"
  exit 2
} 2>/dev/null


create_chaos() {
  kubectl scale --replicas=0 deployment/"$1"
}

create_calm() {
  kubectl scale --replicas="$2" deployment/"$1"
}

main() {
while [ "$#" -gt 0 ]; do
  case "$1" in
    (-h|--help) usage 2>&1;;
    (chaos) create_chaos "$2";;
    (calm) create_calm "$2" "$3";;
    (*) "Invalid argument";;
  esac
  exit 0;
done
}

if [ "$#" -eq 0 ]; then 
  usage && exit 1
  main "$@"
else
  main "$@"
fi