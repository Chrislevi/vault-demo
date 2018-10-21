#!/bin/bash

#export VAULT_SECRET_TOKEN=vault-init-token
#export VAULT_TOKEN=$(kubectl get secret ${VAULT_SECRET_TOKEN} -o json --namespace default | jq --raw-output '.data."unseal.json"' | base64 --decode | jq -r ".root_token")
#export VAULT_TOKEN=root
export VAULT_ADDR=http://127.0.0.1:7199

vault secrets enable database
vault write database/config/mysql \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(172.16.2.31:3306)/" \
    allowed_roles="mysql-*" \
    username="vault" \
    password="iopIOP890vault"

vault write database/roles/mysql-root \
    db_name=mysql \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL PRIVILEGES ON *.* TO '{{name}}'@'%';" \
    default_ttl="15m"

vault write database/roles/mysql-app \
    db_name=mysql \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON *.* TO '{{name}}'@'%';" \
    default_ttl="1h"
