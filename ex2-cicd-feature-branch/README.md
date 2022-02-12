In this exercise we will demonstrate the need for a CICD pipeline to build and deploy properly using terraform.

First in the github actions secrets create the following secrets called:

    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    S3_BACKEND_BUCKET
    S3_BACKEND_KMS_KEY_ID

Looking at ex2-tf-apply you can see that this only occurs on a branch called ex2-main while ex2-tf-plan only executes on branch which start with ex2-main/ . This assumes the naming convention for branches is trunk/feature .

Create a new branch called ex2-main and push it to github. You will see in github actions that the infrastructure is created.

Following this, create two new branches called ex2-main/feature1 and ex2-main/feature2 and push them to github. You will see in github actions that the terraform plan is executed.

After this add two different blocks of code feature 1 and feature 2. S3 buckets are low cost fast resources to create.

Push both up and see the plans - each one only plans to create its own infrastructure.

Create a pull request from ex2-main/feature1 into the ex2-main branch and merge it. You will see in github actions that the terraform apply is executed.

Execute the ex2-main/feature2 workflow again and you will see the feature2 code being added but also the feature2 resources are being planned to be deleted. Merge this into the ex2-main branch through a pull request, and you will see in github actions that the terraform apply is executed however the feature3 resources are not being deleted. This destroy is just noise due to the feature 2 branch being stale compared to ex2-main. Due to this the following workflow is recommended to reduce noise (for feature 2):

git checkout ex2-main
git pull origin ex2-main
git checkout ex2-main/feature2
git merge ex2-main
git push origin ex2-main/feature2

It is recommended this is scripted for consistency.

Repeat the above steps but before pushing feature 2, utilise the above workflow and you will see the noise is reduced.
