#!/bin/bash

echo $TF_VAR_branch

# cat << EOF >> backend.tf
# terraform {
#   # S3 backend statically coded as variables are not supported in backend
#   backend "s3" {
#     bucket     = "$S3_BACKEND_BUCKET"
#     key        = "$TF_VAR_branch/terraform.tfstate"
#     region     = "eu-west-2"
#     encrypt    = true
#     kms_key_id = "$S3_BACKEND_KMS_KEY_ID"
#   }
# }
# EOF

cat << EOF >> config.s3.tfbackend
bucket     = "$S3_BACKEND_BUCKET"
key        = "$TF_VAR_branch/terraform.tfstate"
region     = "$S3_BACKEND_AWS_REGION"
encrypt    = $S3_BACKEND_ENCRYPT
kms_key_id = "$S3_BACKEND_KMS_KEY_ID"
EOF