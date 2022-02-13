In this exercise we will demonstrate the need for a CICD pipeline to build and deploy properly using terraform.

First in the github actions secrets create the following secrets called:

    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    S3_BACKEND_BUCKET
    S3_BACKEND_KMS_KEY_ID

Here a new environment will be created per feature branch.

create a branch called ex3-main and push to main to see how the infrastructure is created.

Notice how certain variables like the s3 bucket name include the var.branch variable to ensure that namespaces are unique.

Create two new branches called ex3-main-feature2 and ex3-main-feature1 and add infra to each.

Push both branches to the remote repo and notice how three different sets of infrastructure is created. Also how feature 1 only exists in the feature 1 env and feature 2 in the feature 2 env with no overlap.

These separated environments are isolated failure domains and allow for git to be used as traditionally.

Additionally, notice how the s3 bucket name removes the \_ character to replace with a -, this sanitises the branch name so that it can be used within a bucket name. This is an additional consideration and may affect the naming convention.

When creating the pull requests, notice how the workflow will execute a terraform plan on the target branch. This is to communicate what would actually happen if merged in - this being used to approve or reject the merge request.

When merging the pull request, the workflow will execute a terraform apply on the target branch. This is to actually perform the changes to the infrastructure.

Finally, when the branch is deleted in the remote repo, this will execute a terraform destroy (as lon as the branch starts with ex3), this is to clean up the infrastructure when a feature branch is complete.
