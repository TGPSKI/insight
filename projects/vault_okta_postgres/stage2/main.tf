data "terraform_remote_state" "vault" {
  backend = "local"

  config = {
    path = "../stage1/terraform.tfstate"
  }
}

locals {
  db_user        = data.terraform_remote_state.vault.outputs.db_user
  db_pass        = data.terraform_remote_state.vault.outputs.db_pass
  db_docker_ip   = data.terraform_remote_state.vault.outputs.db_docker_ip
  db_docker_port = data.terraform_remote_state.vault.outputs.db_docker_port
  db             = data.terraform_remote_state.vault.outputs.db
}

module "vault_okta" {
  source = "../../../modules/vault/okta"

  providers = {
    okta  = okta
    vault = vault
  }

  org_name  = var.org_name
  base_url  = var.base_url
  api_token = var.api_token
}

module "vault_postgres" {
  source = "../../../modules/vault/engines/postgres"

  providers = {
    vault = vault
  }

  pg_conn_url = "postgres://${local.db_user}:${local.db_pass}@${local.db_docker_ip}:${local.db_docker_port}/${local.db}?sslmode=disable"
}
