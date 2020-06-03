# Vault Okta Postgres

This is a full end to end demo of Vault, Okta, and Postgres working together to issue temporary database credentials.

## Stage 1

Creates postgres database and vault cluster via docker provider.

## Stage 2

Creates a terraform vault role for running changes to Vault with terraform. This stage initializes the test database and creates two database roles, ro and rw.

## Stage 3

Creates a Okta authentication server with custom claims and a Okta OAuth app.

## Stage 4

Creates a Vault authentication backend with remote state from Stage 3 and sets up authentication roles.

## Stage 5

Installs a postgres secrets engine to apps/test-app.
