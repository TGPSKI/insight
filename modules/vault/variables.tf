variable "vault_dev_token" {
  type    = string
  default = "vault_dev"
}

variable "vault_listen_ip" {
  type    = string
  default = "0.0.0.0:8200"
}

variable "docker_network_name" {
  type = string
}
