set -x

export PKI_1="intermediate-ca?www.google.com"
export VAULT_LOGIN_ROLE=demo-role
export DEFAULT_SECRET=$(kubectl get serviceaccount default -o jsonpath='{.secrets[0].name}')
export DEFAULT_TOKEN=$(kubectl get secret ${DEFAULT_SECRET} -o json --namespace default | jq --raw-output '.data.token' | base64 --decode)
export VAULT_TOKEN=$(vault write -format=json auth/kubernetes/login role=demo-role jwt=${DEFAULT_TOKEN} | jq -r '.auth.client_token')

INJECTED_PKI_NAMES=$(printenv | grep '^PKI_' | awk -F "=" '{print $1}')

for pki in ${INJECTED_PKI_NAMES}
do
    PKI_NAME=$(echo ${pki} | sed 's/^PKI_//g')
    CA_ISSUE_PATH=$(printenv ${pki} | awk -F "?" '{print $1}')/issue/${VAULT_LOGIN_ROLE}
    COMMON_NAME=$(printenv ${pki} | awk -F "?" '{print $2}')
    OUTPUT=$(vault write -format=json ${CA_ISSUE_PATH} common_name=${COMMON_NAME} | jq -r 'if .errors then . else .data end')
    
    mkdir ${PKI_NAME}
    for key in private_key certificate issuing_ca
    do
        echo ${OUTPUT} | jq -r '.${key}' | tee ${PKI_NAME}/${key}
    done
done
