variable "postgres_options" {
  type = map
  default = {
    user    = "tyler"
    db_name = "insight"
  }
}

variable "docker_network" {
  type = map
  default = {
    network_name = "insight"
  }
}
