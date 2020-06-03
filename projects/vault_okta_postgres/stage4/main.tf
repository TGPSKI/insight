resource "vault_jwt_auth_backend" "example" {
  description        = "Demonstration of the Terraform OIDC auth backend"
  path               = "oidc"
  type               = "oidc"
  oidc_discovery_url = "https://dev-469256.okta.com/oauth2/${data.terraform_remote_state.stage3.outputs.okta_auth_server_id}"
  oidc_client_id     = data.terraform_remote_state.stage3.outputs.okta_client_id
  oidc_client_secret = data.terraform_remote_state.stage3.outputs.okta_client_secret
  default_role       = "test-role"
  tune {
    listing_visibility = "unauth"
  }
}

resource "vault_jwt_auth_backend_role" "example" {
  backend        = vault_jwt_auth_backend.example.path
  role_name      = "test-role"
  token_policies = ["tyler", "default"]

  user_claim            = "sub"
  role_type             = "oidc"
  allowed_redirect_uris = ["http://localhost:8200/ui/vault/auth/oidc/oidc/callback", "http://localhost:8250/oidc/callback"]
  oidc_scopes           = ["openid", "profile", "groups"]
  verbose_oidc_logging  = true

  bound_claims = {
    groups = "Everyone"
  }
}

resource "vault_jwt_auth_backend_role" "admin" {
  backend        = vault_jwt_auth_backend.example.path
  role_name      = "admin"
  token_policies = ["admin", "default"]

  user_claim            = "sub"
  role_type             = "oidc"
  allowed_redirect_uris = ["http://localhost:8200/ui/vault/auth/oidc/oidc/callback", "http://localhost:8250/oidc/callback"]
  oidc_scopes           = ["openid", "profile", "groups"]
  verbose_oidc_logging  = true

  bound_claims = {
    groups = "admin"
  }
}

data "vault_policy_document" "tyler" {
  rule {
    path         = "databases/*"
    capabilities = ["create", "read", "list", "update"]
    description  = "Enable access to database secrets engines."
  }

  rule {
    path         = "sys/leases/*"
    capabilities = ["create", "read", "list", "update", "delete"]
    description  = "Allow Vault users to revoke credential leases."
  }
}

resource "vault_policy" "tyler" {
  name   = "tyler"
  policy = data.vault_policy_document.tyler.hcl
}

data "vault_policy_document" "admin" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "list", "update", "delete", "sudo"]
    description  = "admin role policy"
  }
}

resource "vault_policy" "admin" {
  name   = "admin"
  policy = data.vault_policy_document.admin.hcl
}
