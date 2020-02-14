resource "random_password" "postgres_master" {
  length  = 16
  special = false
}

resource "docker_network" "insight" {
  name   = "insight"
  driver = "bridge"
}

resource "docker_image" "postgres" {
  name = "postgres:10"
}

resource "docker_container" "postgres" {
  name  = "postgres"
  image = docker_image.postgres.latest
  start = true

  ports {
    internal = 5432
    external = 5432
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
    name = var.docker_network.network_name
  }
}
