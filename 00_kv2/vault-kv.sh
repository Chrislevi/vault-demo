#!/bin/bash

KV_PATH="kv2"

vault secrets enable -path=${KV_PATH} kv
vault kv enable-versioning ${KV_PATH}

clear
vault kv put ${KV_PATH}/my-secret my-value=s3cr3t
vault kv get ${KV_PATH}/my-secret
sleep 8

clear
vault kv put ${KV_PATH}/my-secret my-value=mcgregor defeated=true
vault kv get ${KV_PATH}/my-secret
