#!/bin/bash

set -e

##
## Container Management Helper for GCR
## Motiviation: because I don't like typing the same thing over-and-over...hence these scripts!
## Version: 0.0.1-dev
## Maintainers: Kasey Weirich
## License: none, use at your own free will
## ---------------------------------
##
## Usage: container_manager.sh [arguments]
##
##
## Arguments:
##   -h, --help              Displays the help message.
##   provision <image_dir>   Builds, tags, and pushes the container image to the GCR private registry
##

# Global vars
gcr_registry='gcr.io'
project_id='cool-automata-328421'
version_tag='0.1.8' # use bumpversion in production, this is just for development,

usage() {
  [ "$*" ] && echo "$0: $*"
  sed -n '/^##/,/^$/s/^## \{0,1\}//p' "$0"
  exit 2
} 2>/dev/null

provision() {
  echo "Building and pushing ${1}"
  cd ../src/"${1}" && docker build -t "${gcr_registry}/${project_id}/${1}:${version_tag}" .
  docker push "${gcr_registry}/${project_id}/${1}:${version_tag}"
}

main() {
while [ "$#" -gt 0 ]; do
  case "$1" in
    (-h|--help) usage 2>&1;;
    (provision) provision "$2" "$3";;
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