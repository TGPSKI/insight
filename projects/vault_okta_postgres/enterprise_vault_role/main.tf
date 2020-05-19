data "vault_policy_document" "terraform" {
  # Additional capabilities needed to modify system paths
  # See 'sudo' descrption here https://www.vaultproject.io/docs/concepts/policies#capabilities
  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "Allows Terraform to manage objects in Vault that are not root protected."
  }

  rule {
    path         = "auth/*"
    capabilities = ["create", "update", "read", "sudo"]
    description  = "Manage authentication backends broadly across Vault"
  }

  rule {
    path         = "sys/auth/*"
    capabilities = ["create", "update", "sudo"]
    description  = "Create, modify, and delete authentication backends"
  }

  rule {
    path         = "sys/mounts/*"
    capabilities = ["create", "update", "sudo"]
    description  = "Mount and manage secret backends broadly across Vault"
  }

  rule {
    path         = "auth/token/create"
    capabilities = ["create", "update"]
    description  = "Allow terraform role to create short-lived tokens, used as an automatic process by the Vault provider."
  }
}

resource "vault_policy" "terraform" {
  name   = "terraform"
  policy = data.vault_policy_document.terraform.hcl
}

resource "vault_token" "terraform" {
  role_name = "terraform"
  policies  = [vault_policy.terraform.name]
  renewable = false

  depends_on = [
    vault_token_auth_backend_role.terraform,
    vault_policy.terraform
  ]
}

resource "vault_token_auth_backend_role" "terraform" {
  role_name        = "terraform"
  allowed_policies = [vault_policy.terraform.name]
  orphan           = true
  renewable        = false
}
