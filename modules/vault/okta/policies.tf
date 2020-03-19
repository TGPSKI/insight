data "vault_policy_document" "admin" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "Vault admin"
  }
}

data "vault_policy_document" "database" {
  rule {
    path         = "postgres/*"
    capabilities = ["read", "list"]
    description  = "Generate temporary access creds for postgres"
  }
}

data "vault_policy_document" "kv" {
  rule {
    path         = "secret/*"
    capabilities = ["read", "list"]
    description  = "View key value secrets"
  }

  rule {
    path         = "postgres/*"
    capabilities = ["read", "list"]
    description  = "Generate temporary access creds for postgres"
  }
}

resource "vault_policy" "all_access" {
  name   = "admin"
  policy = data.vault_policy_document.admin.hcl
}

resource "vault_policy" "database_only" {
  name   = "database"
  policy = data.vault_policy_document.database.hcl
}

resource "vault_policy" "kv" {
  name   = "database"
  policy = data.vault_policy_document.kv.hcl
}

resource "okta_group" "all_access" {
  name        = "all_access"
  description = "all access"
}

resource "okta_group_roles" "admin" {
  group_id    = okta_group.all_access.id
  admin_roles = ["SUPER_ADMIN"]
}

resource "okta_group" "database_only" {
  name        = "database_only"
  description = "database only"
}

resource "okta_group" "kv" {
  name        = "kv"
  description = "kv"
}

