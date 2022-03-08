# The incompatibility of Git and Terraform

## Introduction - GitOps

GitOps is an operational framework that takes DevOps best practices used for application development such as version control, collaboration, compliance, and CI/CD tooling, and applies them to infrastructure automation. Gitlab have an excellent [article](https://about.gitlab.com/topics/gitops/) explaining the concept of GitOps.

Implementing GitOps with Terraform presents unique challenges - the largest of which being that branching with terraform codebases does not create isolated failure domains as it does with application development.

In this exercise, this challenge will be addressed first hand.

## Prerequisites

To do this exercise you will need:

### Accounts

The followings accounts will be required. No/minimals costs should be incurred in either since the infrastructure created will be absorbed into the free tier of the AWS account.

- GitHub Account
- AWS Account

### Software

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

### Configuring local credentials

It is recommended to configure a local profile just for this exercise using the AWS CLI command below. This is so that secrets are never uploaded to any git repositories.

` aws configure --profile PROFILE_NAME`

## Collaboration Scenario

Imagine yourself and a colleague are both developing the AWS platform for your project. An S3 bucket has already been created via terraform and this has been committed to the git repository. You are now working on feature 1 (create a KMS key) while your colleague is working on feature 2 (create a DynamoDB table).

## Step 2 - Setting up the backend and provider

In order to collaborate with anyone on terraform infrastructure, a remote backend is always required. We will use S3 as our backend for this exercise.

For each folder (main, feature_1 and feature_2) copy Backend.tmpl into a file called backend.tf.

For the backend block, replace the variables with the correct values from an existing S3 backend. If you do not currently have an existing s3 backend, please follow Appendix 1. :

For the provider block, place in the name of the profile used and the region.

Finally run `terraform init` to initialize the backend.

## Step 3 - Create main infrastructure

Within the terminal navigate to the main folder and run `terraform init`.
Then also run `terraform apply` and type yes when prompted.

Two resources will be created:

- An s3 bucket in AWS
- A random_id internalised within Terraform

## Step 4 -Feature 1

Now lets say you are working on feature 1 and you want to create a KMS key.

Within the terminal navigate to the feature_1 folder and notice how it is the same code as main but with your code for your feature.

run `terraform init`.
Then also run `terraform apply` and type yes when prompted.

You will notice how the KMS key is created without issue.

## Step 5 - Feature 2

Now lets say your colleague is simultaneously working on feature 2 and they want to create a DynamoDB table.

run `terraform apply` and type yes when prompted. You will see `Plan: 1 to add, 0 to change, 1 to destroy.` The dynamodb table will be created but the kms key created will be destroyed.

## Cause of the incompatibility

If you keep switching between applying the two feature folders, you will see that the other feature is destroyed every time. This is because of the declarative nature of Terraform. Since each branch does not contain the other's additional code when terraform apply is run, terraform detects the infrastructure being tracked is not in the code and destroys it to make the state match the code.

## Solution

The solution to this is to have Terraform executed in a shared remote platform - ideally a CICD pipeline. This will ensure the infrastructure is always in sync with the code and allows execution to occur within a stable environment. However, this presents a major issue in how Terraform and the environments it manage should be managed within CICD. Two possible solutions are investigated in ex2 and ex3

# Appendix

## Appendix 1: Creating an S3 Backend.

In order to create the infrastructure for the S3 backend, the [nozaq/terraform-aws-s3-backend](https://github.com/nozaq/terraform-aws-remote-state-s3-backend) terraform module is recommended. Using this allows for the infrastructure to be created following all bet practices quickly and easily.

Use the `terraform show` command to show the outputs after creating the backend and get the correct variables for the s3 backend.
