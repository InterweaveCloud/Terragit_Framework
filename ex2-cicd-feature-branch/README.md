In this exercise we will demonstrate the need for a CICD pipeline to build and deploy properly using terraform.

First in the github actions secrets create the following secrets called:

    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    S3_BACKEND_BUCKET
    S3_BACKEND_KMS_KEY_ID

Looking at ex2-tf-apply you can see that this only occurs on a branch called ex2-main while ex2-tf-plan only executes on branch which start with ex2-main/ . This assumes the naming convention for branches is trunk/feature .

Create a new branch called ex2-main and push it to github. You will see in github actions that the infrastructure is created.

Following this, create two new branches called ex2-main_feature1 and ex2-main_feature2 and push them to github. You will see in github actions that the terraform plan is executed.

After this add two different blocks of code feature 1 and feature 2. S3 buckets are low cost fast resources to create.

Push both up and see the plans - each one only plans to create its own infrastructure.

Create a pull request from ex2-main_feature1 into the ex2-main branch and watch the cicd which executes upon merge. it will be the same as the one done initially.

once you merge it. You will see in github actions that the terraform apply is executed.

Execute the ex2-main_feature2 workflow again and you will see the feature2 code being added but also the feature1 resources are being planned to be deleted.

Create a pull request and observe the merge when the pull request cicd is run. Notice how the code in feature1 are not being planned to be deleted anymore, this plan is more accurate and does not contain the same noise.

Approve the pull request, and you will see in github actions that the terraform apply is executed however the feature1 resources are not being deleted.

The planned destroy was just noise due to the feature 2 branch being stale compared to ex2-main. This can be avoided by keeping the feature branch up to date with the trunk branch. Due to this the following workflow is recommended to reduce noise (for feature 2):

git checkout ex2-main
git pull origin ex2-main
git checkout ex2-main_feature2
git merge ex2-main
git push origin ex2-main_feature2

It is recommended this is scripted for consistency.

Repeat the above steps but before pushing feature 2, utilise the above workflow and you will see the noise is reduced.

Remember to create a backend.tf locally and destroy the infrastructure which was created similar to ex1
