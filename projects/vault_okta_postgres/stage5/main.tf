locals {
  postgres_url = "postgres://${data.terraform_remote_state.stage1.outputs.db_user}:${data.terraform_remote_state.stage1.outputs.db_pass}@${data.terraform_remote_state.stage1.outputs.db_docker_ip}:${data.terraform_remote_state.stage1.outputs.db_docker_port}/${data.terraform_remote_state.stage1.outputs.db}?sslmode=disable"
}

module "harbormaster_vault_integration" {
  source = "../../../modules/secrets-engine"

  app_name     = "test-app"
  db_name      = data.terraform_remote_state.stage1.outputs.db
  postgres_url = local.postgres_url

  database_roles = {
    read_only = {
      name        = "read_only"
      default_ttl = 60 * 60 # 1 hour
      max_ttl     = 60 * 60 # 1 hour
      creation_statements = [
        "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
        "GRANT CONNECT ON DATABASE \"${data.terraform_remote_state.stage1.outputs.db}\" TO \"{{name}}\";",
        "GRANT \"ro\" TO \"{{name}}\";"
      ]
    }
    read_write = {
      name        = "read_write"
      default_ttl = 60 * 30 # 30 minutes
      max_ttl     = 60 * 30 # 30 minutes
      creation_statements = [
        "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
        "GRANT CONNECT ON DATABASE \"${data.terraform_remote_state.stage1.outputs.db}\" TO \"{{name}}\";",
        "GRANT \"rw\" TO \"{{name}}\";"
      ]
    }
  }
}
