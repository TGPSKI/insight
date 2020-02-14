data "terraform_remote_state" "root" {
  backend = "local"

  config = {
    path = "../../terraform.tfstate"
  }
}

locals {
  db_user        = data.terraform_remote_state.root.outputs.db_user
  db_pass        = data.terraform_remote_state.root.outputs.db_pass
  db_docker_ip   = data.terraform_remote_state.root.outputs.db_docker_ip
  db_docker_port = data.terraform_remote_state.root.outputs.db_docker_port
  db_table       = data.terraform_remote_state.root.outputs.db_table
}

module "vault_engine" {
  source = "../../modules/vault/engines"

  providers = {
    vault = vault
  }

  pg_conn_url = "postgres://${local.db_user}:${local.db_pass}@${local.db_docker_ip}:${local.db_docker_port}/${local.db_table}?sslmode=disable"
}
