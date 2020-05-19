resource "okta_app_oauth" "example" {
  label = "vault-oidc"
  type  = "web"

  token_endpoint_auth_method = "client_secret_post"

  login_uri = "http://localhost:8250/oidc/callback"

  grant_types    = ["authorization_code", "implicit"]
  redirect_uris  = ["http://localhost:8250/oidc/callback", "http://localhost:8200/ui/vault/auth/oidc/oidc/callback"]
  response_types = ["code", "token", "id_token"]

  lifecycle {
    ignore_changes = [groups]
  }
}

resource "okta_auth_server" "vault" {
  audiences   = ["YOUR_MOTHER"]
  description = "Vault authorization server with custom group claims"
  name        = "Vault"
  issuer_mode = "ORG_URL"
  status      = "ACTIVE"
}

resource "okta_auth_server_policy" "default" {
  auth_server_id   = okta_auth_server.vault.id
  status           = "ACTIVE"
  name             = "Default"
  description      = "Default auth server policy"
  priority         = 1
  client_whitelist = ["ALL_CLIENTS"]
}


resource "okta_auth_server_policy_rule" "allow_all" {
  auth_server_id       = okta_auth_server.vault.id
  policy_id            = okta_auth_server_policy.default.id
  status               = "ACTIVE"
  name                 = "allow all"
  priority             = 1
  group_whitelist      = [data.okta_everyone_group.everyone.id]
  grant_type_whitelist = ["implicit"]
  scope_whitelist      = ["groups", "openid", "profile", "email", "address", "phone", "offline_access"]
}

resource "okta_auth_server_scope" "groups" {
  auth_server_id   = okta_auth_server.vault.id
  metadata_publish = "NO_CLIENTS"
  name             = "groups"
  consent          = "IMPLICIT"
  depends_on       = [okta_auth_server.vault]
}

resource "okta_auth_server_claim" "groups" {
  auth_server_id    = okta_auth_server.vault.id
  name              = "groups"
  status            = "ACTIVE"
  claim_type        = "IDENTITY"
  value_type        = "GROUPS"
  group_filter_type = "REGEX"
  value             = ".*"
  scopes            = ["openid", "groups", "profile"]
  depends_on        = [okta_auth_server_scope.groups]
}

data "okta_everyone_group" "everyone" {}

resource "okta_app_group_assignment" "example" {
  app_id   = okta_app_oauth.example.id
  group_id = data.okta_everyone_group.everyone.id
}
