module "postgres" {
  source = "../../modules/postgres"

  providers = {
    docker = docker
  }
}

module "vault" {
  source = "../../modules/vault"

  providers = {
    docker = docker
  }

  docker_network_name = module.postgres.docker_network_name
}
