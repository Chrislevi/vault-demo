#!/bin/bash

#export VAULT_SECRET_TOKEN=vault-init-token
#export VAULT_TOKEN=$(kubectl get secret ${VAULT_SECRET_TOKEN} -o json --namespace default | jq --raw-output '.data."unseal.json"' | base64 --decode | jq -r ".root_token")
export VAULT_TOKEN=root

vault secrets enable database
vault write database/config/demo-db \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(localhost:3306)/" \
    allowed_roles="mysql-*" \
    username="root" \
    password="root"

vault write database/roles/mysql-root \
    db_name=demo-db \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL PRIVILEGES ON *.* TO '{{name}}'@'%';" \
    default_ttl="15m"

vault write database/roles/mysql-app \
    db_name=demo-db \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON my_app.* TO '{{name}}'@'%';" \
    default_ttl="1h"
