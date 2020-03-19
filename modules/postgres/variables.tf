variable "postgres_options" {
  type = map
  default = {
    user       = "tyler"
    db_name    = "insight"
    db_version = "postgres:10"
    db_port    = "5432"
  }
}

variable "docker_network_name" {
  type    = string
  default = "insight"
}
