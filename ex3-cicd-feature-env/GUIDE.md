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

Once you have pushed this up to the remote repo, this should trigger a the terraform exercise 3 workflow to run and to create the main feature environmment.

It will create a bucket preprended with the branch name.

Now imagine you have two new features to add, one being adding a second s3 bucket and another adding a kms key.

Create a new branch called ex3-add-kms, and the following code in a kms.tf file.
