module "postgres" {
  source = "../../modules/postgres"

  providers = {
    docker = docker
  }

  postgres_options = {
    user       = "tyler"
    db_name    = "insight"
    db_version = "postgres:12"
    db_port    = "5433"
  }

  docker_network_name = "clarity"
}


