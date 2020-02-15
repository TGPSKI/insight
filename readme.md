# Insight

Personal terraform playground.

## Modules

### postgres

Creates a dockerized postgres container and a docker network.

### vault

Creates a dockerized vault dev instance, connected to an existing docker network.

#### vault/engines

Creates a vault secrets engine. Currently supported engines include: 

* postgres secrets engine

## Projects

### Vault

Instantiates a postgres and vault module, connecting the two via a shared docker network.

### Vault Engine

Instantiates a vault/engine module, connecting the secret engine to an existing Vault project.
