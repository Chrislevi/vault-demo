#!/bin/bash

export VAULT_SECRET_TOKEN=vault-init-token
export VAULT_TOKEN=$(kubectl get secret ${VAULT_SECRET_TOKEN} -o json --namespace default | jq --raw-output '.data."unseal.json"' | base64 --decode | jq -r ".root_token")

vault secrets enable transit
vault write -f transit/keys/demo-app-key
vault policy write rewrap ./rewrap.hcl

