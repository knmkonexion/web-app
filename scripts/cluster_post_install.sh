#!/bin/bash

echo 'ATTENTION: this must be ran either within the GCP Cloud Shell or a system that has gcloud installed/configured.'

gcp_region='us-east1-b'
gke_cluster_name='starr-org-development'

##
## Usage: cluster_post_install.sh [arguments]
##
## Arguments:
##   -h, --help              Displays the help message.
##   setup_kubeconfig
##   install_ingress_controller
##

usage() {
  [ "$*" ] && echo "$0: $*"
  sed -n '/^##/,/^$/s/^## \{0,1\}//p' "$0"
  exit 2
} 2>/dev/null

setup_kubeconfig() {
  gcloud container clusters get-credentials "${gke_cluster_name}" --region "${gcp_region}"
}

install_ingress_controller() {
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update
  helm upgrade --install \
    ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    --set controller.service.type=LoadBalancer \
    --version 3.12.0 \
    --create-namespace
  
  echo 'List the ingress controller information, you want to obtain the load balancer IP address'
  kubectl get service ingress-nginx-controller --namespace=ingress-nginx
}

main() {
while [ "$#" -gt 0 ]; do
  case "$1" in
    (-h|--help) usage 2>&1;;
    (setup_kubeconfig) setup_kubeconfig;;
    (install_ingress_controller) install_ingress_controller;;
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