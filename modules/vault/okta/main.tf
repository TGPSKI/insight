locals {
  groups = [
    {
      group_name = okta_group.all_access.name
      policies = [
        vault_policy.all_access.name
      ]
    },
    {
      group_name = okta_group.database_only.name
      policies = [
        vault_policy.database_only.name
      ]
    },
    {
      group_name = okta_group.kv.name
      policies = [
        vault_policy.kv.name
      ]
    }
  ]
}

resource "vault_okta_auth_backend" "dev" {
  description     = "Allow vault login with okta"
  path            = "okta"
  bypass_okta_mfa = true
  organization    = var.org_name
  base_url        = var.base_url
  token           = var.api_token
}

resource "vault_okta_auth_backend_group" "dev" {
  # Associate Okta groups with policies within Vault. 
  count      = length(local.groups)
  path       = vault_okta_auth_backend.dev.path
  group_name = local.groups[count.index]["group_name"]
  policies   = local.groups[count.index]["policies"]
}
