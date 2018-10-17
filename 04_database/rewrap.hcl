path "transit/keys/my_app_key" {
  capabilities = ["read"]
}

path "transit/rewrap/my_app_key" {
  capabilities = ["update"]
}

path "transit/encrypt/my_app_key" {
  capabilities = ["update"]
}
