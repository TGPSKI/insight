output "okta_auth_server_id" {
  value = okta_auth_server.vault.id
}

output "okta_client_id" {
  value = okta_app_oauth.example.client_id
}

output "okta_client_secret" {
  value = okta_app_oauth.example.client_secret
}
