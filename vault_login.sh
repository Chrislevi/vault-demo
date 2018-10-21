#!/bin/bash
set -x

export VAULT_ADDR=http://127.0.0.1:7199
echo "vault status:"
vault status

vault login 3xSsysQg4GY6yEUhfm64JYHw
