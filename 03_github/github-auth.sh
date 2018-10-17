#!/bin/bash


export VAULT_SECRET_TOKEN=vault-init-token
export VAULT_TOKEN=$(kubectl get secret ${VAULT_SECRET_TOKEN} -o json --namespace default | jq --raw-output '.data."unseal.json"' | base64 --decode | jq -r ".root_token")

ORG="tikalk"
TEAM="tikal-devops"
POLICY="vault-admin"

vault policy write ${POLICY} admin-policy.hcl

vault auth enable github
vault write auth/github/config organization=${ORG} ttl=20m
vault write auth/github/map/teams/${TEAM} value=${POLICY}


