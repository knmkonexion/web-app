#!/bin/bash

# Used for bootstrapping the cluster after it has been provisioned

setup_kubeconfig() {
  # Note - this is only for GKE
  gcloud container clusters get-credentials starr-org-development --zone us-east1-b --project cool-automata-328421
}

create_namespaces() {
  kubectl create ns monitoring
  kubectl create ns delivery
}

install_prometheus() {
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update
  cd ../helm-charts/prometheus/ && helm install prometheus-stack -n monitoring -f override-values.yaml prometheus-community/kube-prometheus-stack
}

install_argocd() {
  helm repo add argo https://argoproj.github.io/argo-helm
  helm install argocd -n delivery -f ../helm-charts/argocd/override-values.yaml argo/argo-cd

  argo_password=$(kubectl -n delivery get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
  echo 'admin'
  echo "${argo_password}"
}

### ArgoCD will manage these charts as part of Continuous Deployment
### Otherwise, uncomment and run these functions to manually deploy.
##
# install_webapp() {
#   helm install web-app ../helm-charts/web-app/
# }

# install_elasticsearch() {
#   helm install elasticsearch -n monitoring ../helm-charts/elasticsearch/
# }

# install_heartbeat() {
#   helm install heartbeat -n monitoring ../helm-charts/heartbeat/
# }

# install_kibana() {
#   helm install kibana -n monitoring ../helm-charts/kibana/
# }

# install_grafana() {
#   helm install grafana -n monitoring ../helm-charts/grafana/
# }

main() {
  setup_kubeconfig
  create_namespaces
  install_prometheus && sleep 30
  install_argocd
}

main