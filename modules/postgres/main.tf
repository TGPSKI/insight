resource "random_password" "postgres_master" {
  length  = 16
  special = false
}

resource "random_string" "container_name" {
  length  = 8
  special = false
  upper   = false
}

resource "docker_network" "insight" {
  name   = var.docker_network_name
  driver = "bridge"
}

resource "docker_image" "postgres" {
  name = var.postgres_options.db_version
}

resource "docker_container" "postgres" {
  name  = "postgres-${random_string.container_name.result}"
  image = docker_image.postgres.latest
  start = true

  ports {
    internal = 5432
    external = var.postgres_options.db_port
  }

  env = [
    "POSTGRES_USER=${var.postgres_options.user}",
    "POSTGRES_PASSWORD=${random_password.postgres_master.result}",
    "POSTGRES_DB=${var.postgres_options.db_name}",
    "GOSU_VERSION=1.11",
    "LANG=en_US.utf8",
    "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/postgresql/10/bin",
    "PGDATA=/var/lib/postgresql/data",
    "PG_MAJOR=10",
    "PG_VERSION=10.11-1.pgdg90+1"
  ]

  networks_advanced {
    name = var.docker_network_name
  }
}
