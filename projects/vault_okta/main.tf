module "vault_okta" {
  source = "../../modules/vault/okta"

  providers = {
    okta  = okta
    vault = vault
  }

  org_name  = var.org_name
  base_url  = var.base_url
  api_token = var.api_token
}
