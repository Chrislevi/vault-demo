path "secret/demo" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

path "aws/creds/demo-role" {
  capabilities = ["read"]

}

path "intermediate-ca/issue/demo-role" {
  capabilities = ["update"]
}

path "PKI/intermediate-ca/issue/demo-role" {
  capabilities = ["update"]
}

path "PKI/intermediate-ca/issue/demo-role" {
  capabilities = ["update"]
}
