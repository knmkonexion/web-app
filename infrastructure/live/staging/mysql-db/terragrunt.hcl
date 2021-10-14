include {
  path = find_in_parent_folders()
}

locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

terraform {
  source = "../../../modules/gcp-cloud-sql"
}

inputs = {
  project = local.env.project

  name = join("-", [local.common.org, local.env.env])
  region       = local.env.region
  zones        = ["us-east1-b"]

  engine                 = "MYSQL_8_0"
  machine_type           = "db-g1-small"
  db_name                = "blog"
  master_user_name       = "root"
  master_user_password   = "vault_secrets"
}