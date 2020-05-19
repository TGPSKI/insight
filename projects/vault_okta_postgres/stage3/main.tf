data "vault_policy_document" "tyler" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "update"]
    description  = "tyler role policy"
  }
}

resource "vault_policy" "tyler" {
  name   = "tyler"
  policy = data.vault_policy_document.tyler.hcl
}

data "vault_policy_document" "admin" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "sudo"]
    description  = "admin role policy"
  }
}

resource "vault_policy" "admin" {
  name   = "admin"
  policy = data.vault_policy_document.admin.hcl
}

resource "vault_jwt_auth_backend_role" "example" {
  backend        = vault_jwt_auth_backend.example.path
  role_name      = "test-role"
  token_policies = ["tyler"]

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
  token_policies = ["admin"]

  user_claim            = "sub"
  role_type             = "oidc"
  allowed_redirect_uris = ["http://localhost:8200/ui/vault/auth/oidc/oidc/callback", "http://localhost:8250/oidc/callback"]
  oidc_scopes           = ["openid", "profile", "groups"]
  verbose_oidc_logging  = true

  bound_claims = {
    groups = "admin"
  }
}

resource "vault_jwt_auth_backend" "example" {
  description        = "Demonstration of the Terraform OIDC auth backend"
  path               = "oidc"
  type               = "oidc"
  oidc_discovery_url = "https://dev-469256.okta.com/oauth2/auscn33lnnoZY30Zi4x6"
  oidc_client_id     = okta_app_oauth.example.client_id
  oidc_client_secret = okta_app_oauth.example.client_secret
  default_role       = "test-role"
  tune {
    listing_visibility = "unauth"
  }
}
