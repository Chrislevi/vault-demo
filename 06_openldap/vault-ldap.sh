#!/bin/bash
set -x
export VAULT_ADDR=http://127.0.0.1:7199

vault auth enable ldap
vault policy write ldap-db-read ./policy.hcl

vault write auth/ldap/config \
    url="ldap://ldap.sdev.munio.local" \
    userattr="uid" \
    userdn="ou=users,dc=munio,dc=local" \
    groupattr="gidNumber" \
    groupdn="ou=groups,dc=munio,dc=local" \
    binddn="uid=rosa,ou=users,dc=munio,dc=local" \
    groupfilter="(objectClass=*)" \
    bindpass="abcd" \
    starttls=true \
    insecure_tls=false \
    certificate=@/tmp/svc_ldap.crt

vault write auth/ldap/groups/sudoers policies=ldap-db-read


