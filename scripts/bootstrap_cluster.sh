#!/bin/bash

# Used for bootstrapping the cluster after it has been provisioned

create_namespaces() {
  kubectl create ns monitoring
}

install_prometheus() {
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update
  cd ../helm-charts/prometheus/ && helm install prometheus-stack -n monitoring -f override-values.yaml prometheus-community/kube-prometheus-stack
}

install_webapp() {
  helm install web-app ../helm-charts/web-app/
}

install_elasticsearch() {
  helm install elasticsearch -n monitoring ../helm-charts/elasticsearch/
}

install_heartbeat() {
  helm install heartbeat -n monitoring ../helm-charts/heartbeat/
}

install_kibana() {
  helm install kibana -n monitoring ../helm-charts/kibana/
}

install_grafana() {
  helm install grafana -n monitoring ../helm-charts/grafana/
}

main() {
  create_namespaces
  install_prometheus && sleep 30
  install_webapp && sleep 30
  install_elasticsearch && sleep 30
  install_heartbeat
  install_kibana
  install_grafana
}

main