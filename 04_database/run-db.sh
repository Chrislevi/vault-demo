#!/bin/bash
set -x

export VAULT_TOKEN=root
export VAULT_ADDR=http://localhost:8200

OUTPUT=$(vault read -format=json database/creds/$1 | jq -r '.data.')
USERNAME=$(echo ${OUTPUT} | jq -r '.username')
PASSWORD=$(echo ${OUTPUT} | jq -r '.password')
docker exec -it $(docker ps --format '{{json .Names}}' | grep -i mysql | head -1 | tr -d '"') mysql -u${USERNAME} -p${PASSWORD}
