#!/bin/bash

ORG="tikalk"
TEAM="tikal-devops"
POLICY="vault-admin"

vault policy write ${POLICY} -<<EOF
path "secret/demo" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

path "sys/policy/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
EOF

vault auth enable github
vault write auth/github/config organization=${ORG} ttl=20m
vault write auth/github/map/teams/${TEAM} value=${POLICY}


