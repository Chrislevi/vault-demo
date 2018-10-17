#!/bin/bash

vault secrets enable aws
vault write aws/config/root \
    access_key=AKIAIEDTZ7MKUIFPLSLA \
    secret_key=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 \
    region=us-east-1

vault write aws/roles/demo-role policy=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
