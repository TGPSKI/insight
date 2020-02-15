output "db_user" {
  value = module.postgres.db_info.user
}

output "db_pass" {
  value = module.postgres.db_info.pass
}

output "db_docker_ip" {
  value = module.postgres.docker_postgres_ip
}

output "db_docker_port" {
  value = module.postgres.db_info.port
}

output "db_table" {
  value = module.postgres.db_info.name
}
