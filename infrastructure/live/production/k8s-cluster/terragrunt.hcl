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
  zones        = ["us-east1-b", "us-west1-a". "europe-west2-a"]

  machine_type = "n2-standard-16"
  min_nodes    = 6
  max_nodes    = 10

  disk_size = 50

  preemptible = false
}