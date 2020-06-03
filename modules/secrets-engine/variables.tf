variable "app_name" {
  type        = string
  description = "Application name for the Vault database secret backend connection."
}

variable "db_name" {
  type        = string
  description = "Target database name for creation of temporary credentials."
}

variable "allowed_roles" {
  type        = set(string)
  description = "Allowed Vault role names that can interact with the database secret backend connection."
  default     = ["engineer", "admin"]
}

variable "postgres_url" {
  type        = string
  description = "URL used to connect to the postgres database."
}

variable "database_roles" {
  type = map(object({
    name                = string
    default_ttl         = number
    max_ttl             = number
    creation_statements = list(string)
  }))
  description = "Database roles to create with the secret backend connection. Names must be unique. Creation statements must create roles and grant permissions."
}
