resource "vault_mount" "postgres" {
  path = "databases/${var.app_name}"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  # The resource name must match the DB name. If the name does not match, Vault cannot resolve the connection. 
  name          = var.db_name
  allowed_roles = keys(var.database_roles)
  backend       = vault_mount.postgres.path

  postgresql {
    connection_url = var.postgres_url
  }
}

resource "vault_database_secret_backend_role" "role" {
  for_each = var.database_roles

  backend             = vault_mount.postgres.path
  name                = each.value.name
  db_name             = var.db_name
  default_ttl         = each.value.default_ttl
  max_ttl             = each.value.max_ttl
  creation_statements = each.value.creation_statements
}
