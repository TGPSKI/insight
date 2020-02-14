module "postgres" {
  source = "./modules/postgres"
}

module "vault" {
  source = "./modules/vault"

  docker_network_name = module.postgres.docker_network_name
}

module "vault_engine" {
  source = "./modules/vault/engines"

  pg_conn_url = "postgres://${module.postgres.db_info.user}:${module.postgres.db_info.pass}@${module.postgres.docker_postgres_ip}:${module.postgres.db_info.port}/${module.postgres.db_info.name}?sslmode=disable"
}
