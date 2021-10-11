#!/bin/bash

set -e

# Global vars
KERNEL_TYPE='linux_amd64'
TF_VERSION='1.0.8'
TG_VERSION='0.34.1'
KUBECTL_VERSION='1.22.0'

echo "
This script will install the following dependencies (if you don't already have them installed):
[Supported System]
${KERNEL_TYPE}

terraform: ${TF_VERSION}
terragrunt: ${TG_VERSION}
kubectl: ${KUBECTL_VERSION}
"

install_message() {
  if [ "$1" == 'installing' ]; then
    echo "Installing $2...."
    echo '------------------------------'
  elif [ "$1" == 'installed' ]; then
    echo "[SUCCESS] - $2 installed"
  else
    echo ''
  fi
}

install_terraform() {
  install_message installing terraform
  curl -O https://releases.hashicorp.com/terraform/"${TF_VERSION}"/terraform_"${TF_VERSION}"_"${KERNEL_TYPE}".zip
  unzip terraform_"${TF_VERSION}"_"${KERNEL_TYPE}".zip
  chmod a+x terraform
  sudo mv terraform /usr/local/bin/terraform
  rm terraform_"${TF_VERSION}"_"${KERNEL_TYPE}".zip
  install_message installed terraform
  terraform --version
  install_message
}

install_terragrunt() {
  install_message installing terragrunt
  wget https://github.com/gruntwork-io/terragrunt/releases/download/v"${TG_VERSION}"/terragrunt_"${KERNEL_TYPE}"
  chmod a+x terragrunt_"${KERNEL_TYPE}"
  sudo mv terragrunt_"${KERNEL_TYPE}" /usr/local/bin/terragrunt
  install_message installed terragrunt
  terragrunt --version
  install_message
}

install_kubectl() {
  install_message installing kubectl
  curl -LO https://dl.k8s.io/release/v"${KUBECTL_VERSION}"/bin/linux/amd64/kubectl
  chmod a+x kubectl
  sudo mv kubectl /usr/local/bin/kubectl
  install_message installed kubectl
  kubectl version --short
  install_message
}

install_terraform
install_terragrunt
install_kubectl