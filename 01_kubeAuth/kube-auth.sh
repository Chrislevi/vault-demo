#!/bin/sh
#set -x

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true
export KUBE_ACC="vault-tokenreview"
export SERVICE_ACC="demo-app"

kubectl create serviceaccount ${SERVICE_ACC}
kubectl create serviceaccount ${KUBE_ACC} 
export SECRET_NAME=$(kubectl get serviceaccount ${KUBE_ACC} -o jsonpath='{.secrets[0].name}')
export TR_ACCOUNT_TOKEN=$(kubectl get secret ${SECRET_NAME} -o jsonpath='{.data.token}' | base64 --decode)

#export KUBE_API="$(kubectl cluster-info | head -1 | awk '{print $6}')"
export KUBE_API="https://192.168.99.112:8443"
kubectl apply -f clusterbinding.yaml

vault auth enable kubernetes
vault write auth/kubernetes/config \
    token_reviewer_jwt="${TR_ACCOUNT_TOKEN}" \
    kubernetes_host=${KUBE_API} \
    kubernetes_ca_cert=@/Users/chrislevi/.minikube/ca.crt

vault write sys/policy/demo-policy policy=-<<EOF
path "secret/demo" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

path "aws/creds/demo-role" {
  capabilities = ["read"]

}
EOF
vault write auth/kubernetes/role/demo-role \
    bound_service_account_names=${SERVICE_ACC} \
    bound_service_account_namespaces=default \
    policies=demo-policy \
    ttl=8h 

export DEFAULT_SECRET=$(kubectl get serviceaccount ${SERVICE_ACC} -o jsonpath='{.secrets[0].name}')
export DEFAULT_TOKEN=$(kubectl get secret ${DEFAULT_SECRET} -o json --namespace default | jq --raw-output '.data.token' | base64 --decode)
export DEFAULT_LOGIN_TOKEN=$(vault write -format=json auth/kubernetes/login role=demo-role jwt=${DEFAULT_TOKEN} | jq -r '.auth.client_token')

echo ${DEFAULT_LOGIN_TOKEN}


