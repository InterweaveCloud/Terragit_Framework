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

Create two new branches off ex3-main called ex3-add-kms and ex3-add-s3, and push this to the remote repo. Against you will see two new bucket created prepended with the branch name, so you now have three buckets total.

git checkout ex3-main
git checkout -b ex3-add-kms
git push origin ex3-add-kms

git checkout ex3-main
git checkout -b ex3-add-s3
git push origin ex3-add-s3

From this, it is clear that branches now each have their own environment. Key to enabling this is ensuring namespaces do not overlap. Where namespaces such as s3 are globally scoped or account scoped, the branch variable is used to differentiate the resources created for each feature branch.

Looking at variables.tf you can see the branch variable is detected from the environment. Within main.tf you can see var.branch is used within the s3 bucket name as this is a global namespace shared across users.

Within the support_scripts/set-branch-env-var.sh, you can see the TF_VAR_branch is set to the branch name. Additionally, it grabs this information from different sources of the github event, adapting to where the information is (if it is a pull, merge, delete event etc).
