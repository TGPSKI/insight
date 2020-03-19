data "terraform_remote_state" "vault" {
  backend = "local"

  config = {
    path = "../vault/terraform.tfstate"
  }
}

locals {
  db_user        = data.terraform_remote_state.vault.outputs.db_user
  db_pass        = data.terraform_remote_state.vault.outputs.db_pass
  db_docker_ip   = data.terraform_remote_state.vault.outputs.db_docker_ip
  db_docker_port = data.terraform_remote_state.vault.outputs.db_docker_port
  db             = data.terraform_remote_state.vault.outputs.db
}

module "vault_postgres" {
  source = "../../modules/vault/engines/postgres"

  providers = {
    vault = vault
  }

  pg_conn_url = "postgres://${local.db_user}:${local.db_pass}@${local.db_docker_ip}:${local.db_docker_port}/${local.db}?sslmode=disable"
}
