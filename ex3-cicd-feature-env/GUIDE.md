This exercise aims to demonstrate the use of Terraform with Github Actions to automate the deployment of a feature environments with CICD.

To begin with, fork the repository and open it locally using git.

Then you must add the following secrets to the github repo:

Secrets:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

Config for S3 Backend
S3_BACKEND_BUCKET:
S3_BACKEND_KMS_KEY_ID:

To begin with, you must create a branch called "ex3-main" and push this up to the repo.
