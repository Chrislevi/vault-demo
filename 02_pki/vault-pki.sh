#!/bin/bash
set -x

export VAULT_CA_PATH="PKI/root-ca"
export VAULT_INTER_PATH="PKI/intermediate-ca"
export VAULT_SVC="vault"

# Enable root ca
vault secrets enable -path=${VAULT_CA_PATH} -max-lease-ttl=87600h pki
vault write ${VAULT_CA_PATH}/root/generate/internal common_name="Root CA" ttl=87600h exclude_cn_from_sans=true
vault write ${VAULT_CA_PATH}/config/urls issuing_certificates="http://${VAULT_SVC}:8200/v1/${VAULT_CA_PATH}/ca" \
    crl_distribution_points="http://${VAULT_SVC}:8200/v1/${VAULT_CA_PATH}/crl"

# Enable intermediate ca
vault secrets enable -path=${VAULT_INTER_PATH} -max-lease-ttl=43800h pki
vault write -format=json ${VAULT_INTER_PATH}/intermediate/generate/internal \
    common_name="Intermediate CA" ttl=43800h exclude_cn_from_sans=true | \
    jq -r '.data.csr' | tee inter.csr

# sign intermediate cert
vault write -format=json ${VAULT_CA_PATH}/root/sign-intermediate \
    csr=@inter.csr use_csr_values=true exclude_cn_from_sans=true | \
    jq -r '.data.certificate' | tee signed.crt

# upload intermediate cert
vault write ${VAULT_INTER_PATH}/intermediate/set-signed certificate=@signed.crt
vault write ${VAULT_INTER_PATH}/config/urls issuing_certificates="http://${VAULT_SVC}:8200/v1/${VAULT_INTER_PATH}/ca" \
    crl_distribution_points="http://${VAULT_SVC}:8200/v1/${VAULT_INTER_PATH}/crl"


# --------------------------------- configure roles ---------------------------#
vault write ${VAULT_INTER_PATH}/roles/demo-role allow_any_name=true max_ttl="24h"

vault read -format=json sys/policy/demo-policy | jq -r '.data.rules' | tee demo-policy.hcl
cat <<EOF >> demo-policy.hcl
path "${VAULT_INTER_PATH}/issue/demo-role" {
  capabilities = ["update"]
}
EOF

vault policy write demo-policy demo-policy.hcl
