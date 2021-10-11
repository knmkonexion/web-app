include {
  path = find_in_parent_folders()
}

locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

terraform {
  source = "../../../modules/gcp-gke"
}

inputs = {
  project_id = local.env.project

  cluster_name = join("-", [local.common.org, local.env.env])
  region       = local.env.region
  zones        = ["us-east1-b"]

  machine_type = "e2-standard-2"
  min_nodes    = 3
  max_nodes    = 5

  disk_size = 10

  preemptible = false
}