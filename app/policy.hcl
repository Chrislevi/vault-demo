path "secret/demo" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/approle/role/demo-role/role-id" {
  capabilities = ["read"]
}

path "auth/approle/role/demo-role/secret-id" {
  capabilities = ["update"]

}

path "aws/creds/demo-role" {
  capabilities = ["read"]
}

path "intermediate-ca/issue/kubernetes-vault" {
  capabilities = ["update", "create"]
}
