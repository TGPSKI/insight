data "vault_policy_document" "mount" {
  rule {
    path         = "sys/auth/oidc"
    capabilities = ["create", "read", "update", "delete", "sudo"]
    description  = "Mount the OIDC auth method"
  }
}

data "vault_policy_document" "configure" {
  rule {
    path         = "auth/oidc/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "Configure the OIDC auth method"
  }
}

data "vault_policy_document" "write" {
  rule {
    path         = "sys/policies/acl/*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "Write ACL policies"
  }
}

data "vault_policy_document" "list" {
  rule {
    path         = "sys/mounts"
    capabilities = ["read"]
    description  = "List available secrets engines to retrieve accessor ID"
  }
}

resource "vault_policy" "mount" {
  name   = "mount"
  policy = data.vault_policy_document.mount.hcl
}

resource "vault_policy" "configure" {
  name   = "configure"
  policy = data.vault_policy_document.configure.hcl
}

resource "vault_policy" "write" {
  name   = "write"
  policy = data.vault_policy_document.write.hcl
}

resource "vault_policy" "list" {
  name   = "list"
  policy = data.vault_policy_document.list.hcl
}

