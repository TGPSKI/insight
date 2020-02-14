output "db_info" {
  value = {
    pass = random_password.postgres_master.result
    user = var.postgres_options.user
    db   = var.postgres_options.db_name
    port = docker_container.postgres.ports[0].external
    name = docker_container.postgres.name
  }
}

output "docker_postgres_ip" {
  value = docker_container.postgres.network_data[0].ip_address
}

output "docker_network_name" {
  value = docker_network.insight.name
}
