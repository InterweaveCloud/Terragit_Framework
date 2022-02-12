In this exercise we will demonstrate the need for a CICD pipeline to build and deploy properly using terraform.

First in the github actions secrets create the following secrets called:

    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    S3_BACKEND_BUCKET
    S3_BACKEND_KMS_KEY_ID

Here a new environment will be created per feature branch.

create a branch called ex3-main and push to main to see how the
