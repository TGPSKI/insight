resource "docker_image" "vault" {
  name = "vault:1.3.2"
}

resource "docker_container" "vault" {
  name  = "vault"
  image = docker_image.vault.latest
  start = true

  ports {
    internal = 8200
    external = 8200
  }

  env = [
    "VAULT_DEV_ROOT_TOKEN_ID=${var.vault_dev_token}",
    "VAULT_DEV_LISTEN_ADDRESS=${var.vault_listen_ip}",
    "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    "VAULT_LOG_LEVEL=debug"
  ]

  networks_advanced {
    name = var.docker_network_name
  }
}
