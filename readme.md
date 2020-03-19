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

#### vault/okta

Sets up an okta authentication method, okta groups, and vault policies to create an okta + vault integration.

## Projects

### Append Principal IAM

Append a principal statement to an existing IAM policy data source.

### File Templates

File templating test playground.

### Postgres

Instantiates a standalone postgres container.

### Vault

Instantiates a postgres and vault module, connecting the two via a shared docker network.

### Vault Okta

Instantiates a vault/okta module, connecting the okta integration to an existing Vault project.

### Vault Postgres

Instantiates a vault/engine/postgres module, connecting the secret engine to an existing Vault project.
