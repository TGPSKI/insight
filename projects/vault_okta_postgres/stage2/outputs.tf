output "token" {
  description = "Vault authentication token for the Terraform role"
  value       = vault_token.terraform.client_token
}
