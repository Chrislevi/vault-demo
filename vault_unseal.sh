#!/bin/bash
set -x

export VAULT_ADDR=http://127.0.0.1:7199
echo "vault status:"
vault status

vault operator unseal n2z6Y1U1VvVkMDKRdvQ2B+ui7mezps5E5Ys13BzboCQZ
vault operator unseal GMqtNBk2f2QEb5p+t3ZNsJOmxwTUk0w1XoZtvPMz5rkW
vault operator unseal xarPzX0bEPmzvm+bN+gvpGsbe+NjmrsXXTfZf5RIqciy
vault operator unseal XpLh675jy/goxs4HUkrfttdlJhP5r0x5xoE+oKFB+UrX
vault operator unseal Rz4+6GbLZr3D2QQL6bcFpzXkvVL01FBKMpmOn9UJ7AE4

