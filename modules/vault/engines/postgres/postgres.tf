resource "vault_mount" "db" {
  path = "postgres"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.db.path
  name          = var.db_name
  allowed_roles = ["dev"]

  postgresql {
    connection_url = var.pg_conn_url
  }
}

resource "vault_database_secret_backend_role" "role" {
  backend             = vault_mount.db.path
  name                = "dev"
  db_name             = var.db_name
  default_ttl         = 60 * 60      # 1 hr
  max_ttl             = 60 * 60 * 24 # 1 day
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';", "GRANT CONNECT ON DATABASE insight TO \"{{name}}\";"]
}

