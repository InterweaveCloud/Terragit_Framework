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

Imagine yourself and a colleague are both developing the AWS platform for your project. An S3 bucket has already been created via terraform and this has been committed to the git repository. You are now working on feature 1 (create a dynamodb table) while your colleague is working on feature 2 (create a KMS key).

## Step 2 - Setting up the backend and provider

In order to collaborate with anyone on terraform infrastructure, a remote backend is always required. We will use S3 as our backend for this exercise.

For each folder (main, feature_1 and feature_2) copy Backend.tmpl into a file called backend.tf.

For the backend block, replace the variables with the correct values from an existing S3 backend. If you do not currently have an existing s3 backend, please follow Appendix 1. :

For the provider block, place in the name of the profile used and the region.

Finally run `terraform init` to initialize the backend.

## Step 3 - Create main infrastructure

Navigate to the main folder in terminal using the `cd` command. You can check which folder you are in using the `ls` command. Once in the main folder run the following commands in the order it is written in:

```
terraform init
terraform apply
```

After running the `terraform init` command your terminal should look like the following:

```

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v3.74.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

After running the `terraform apply` command your terminal should look like the following:

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.TestBucket786 will be created
  + resource "aws_s3_bucket" "TestBucket786" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "my-tf-test-bucket-786"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Environment" = "Dev"
          + "Name"        = "My bucket"
        }
      + tags_all                    = {
          + "Environment" = "Dev"
          + "Name"        = "My bucket"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

Once you enter `yes` into the terminal, your terminal should look like the following:

```
aws_s3_bucket.TestBucket786: Creating...
aws_s3_bucket.TestBucket786: Creation complete after 1s [id=my-tf-test-bucket-786]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

The commands will initialize the backend and create the S3 bucket.

Note: For `terraform apply` you will be required to approve the actions

## Step 4

In a new terminal, navigate to the feature_1 folder using the `cd` command. You can check which folder you are in using the `ls` command. Once in the feature_1 folder run the following command:

```
terraform apply
```

Once you have run the terraform apply in your terminal, your terminal should look like this:

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_s3_bucket.TestBucket786 will be updated in-place
  ~ resource "aws_s3_bucket" "TestBucket786" {
        id                          = "my-tf-test-bucket-786"
        tags                        = {
            "Environment" = "Dev"
            "Name"        = "My bucket"
        }
        # (10 unchanged attributes hidden)

      + lifecycle_rule {
          + enabled = true
          + prefix  = "config/"

          + noncurrent_version_expiration {
              + days = 90
            }

          + noncurrent_version_transition {
              + days          = 30
              + storage_class = "STANDARD_IA"
            }
          + noncurrent_version_transition {
              + days          = 60
              + storage_class = "GLACIER"
            }
        }

      ~ versioning {
          ~ enabled    = false -> true
            # (1 unchanged attribute hidden)
        }
    }

Plan: 0 to add, 1 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

Once you enter the value `yes` your terminal should look like the following:

```
aws_s3_bucket.TestBucket786: Modifying... [id=my-tf-test-bucket-786]
aws_s3_bucket.TestBucket786: Modifications complete after 1s [id=my-tf-test-bucket-786]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

The command will make changes and modify S3 bucket. The changes are it will add lifecycle rules and enable versioning

Note: For `terraform apply` you will be required to approve the actions

## Step 5

In a new terminal, navigate to the feature_2 folder using the `cd` command. You can check which folder you are in using the `ls` command. Once in the feature_2 folder run the following command:

```
terraform apply
```

Once you have run the `terraform apply` command, your terminal should look like this:

```
aws_s3_bucket.TestBucket786: Refreshing state... [id=my-tf-test-bucket-786]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply":

  # aws_s3_bucket.TestBucket786 has changed
  ~ resource "aws_s3_bucket" "TestBucket786" {
        id                          = "my-tf-test-bucket-786"
        tags                        = {
            "Environment" = "Dev"
            "Name"        = "My bucket"
        }
        # (10 unchanged attributes hidden)

      + lifecycle_rule {
          + abort_incomplete_multipart_upload_days = 0
          + enabled                                = true
          + id                                     = "tf-s3-lifecycle-20220221194639372700000001"
          + prefix                                 = "config/"
          + tags                                   = {}

          + noncurrent_version_expiration {
              + days = 90
            }

          + noncurrent_version_transition {
              + days          = 30
              + storage_class = "STANDARD_IA"
            }
          + noncurrent_version_transition {
              + days          = 60
              + storage_class = "GLACIER"
            }
        }

        # (1 unchanged block hidden)
    }


Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or respond to
these changes.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place

Terraform will perform the following actions:

  # aws_kms_key.mykey will be created
  + resource "aws_kms_key" "mykey" {
      + arn                                = (known after apply)
      + bypass_policy_lockout_safety_check = false
      + customer_master_key_spec           = "SYMMETRIC_DEFAULT"
      + deletion_window_in_days            = 10
      + description                        = "This key is used to encrypt bucket objects"
      + enable_key_rotation                = false
      + id                                 = (known after apply)
      + is_enabled                         = true
      + key_id                             = (known after apply)
      + key_usage                          = "ENCRYPT_DECRYPT"
      + multi_region                       = (known after apply)
      + policy                             = (known after apply)
      + tags_all                           = (known after apply)
    }

  # aws_s3_bucket.TestBucket786 will be updated in-place
  ~ resource "aws_s3_bucket" "TestBucket786" {
        id                          = "my-tf-test-bucket-786"
        tags                        = {
            "Environment" = "Dev"
            "Name"        = "My bucket"
        }
        # (10 unchanged attributes hidden)

      - lifecycle_rule {
          - abort_incomplete_multipart_upload_days = 0 -> null
          - enabled                                = true -> null
          - id                                     = "tf-s3-lifecycle-20220221194639372700000001" -> null
          - prefix                                 = "config/" -> null
          - tags                                   = {} -> null

          - noncurrent_version_expiration {
              - days = 90 -> null
            }

          - noncurrent_version_transition {
              - days          = 30 -> null
              - storage_class = "STANDARD_IA" -> null
            }
          - noncurrent_version_transition {
              - days          = 60 -> null
              - storage_class = "GLACIER" -> null
            }
        }

      + server_side_encryption_configuration {
          + rule {
              + apply_server_side_encryption_by_default {
                  + kms_master_key_id = (known after apply)
                  + sse_algorithm     = "aws:kms"
                }
            }
        }

        # (1 unchanged block hidden)
    }

Plan: 1 to add, 1 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

Once you have entered `yes` your terminal should look like this:

```
aws_kms_key.mykey: Creating...
aws_kms_key.mykey: Creation complete after 0s [id=4f77fa38-23ca-4462-93e4-6dca26fca034]
aws_s3_bucket.TestBucket786: Modifying... [id=my-tf-test-bucket-786]
aws_s3_bucket.TestBucket786: Modifications complete after 1s [id=my-tf-test-bucket-786]

Apply complete! Resources: 1 added, 1 changed, 0 destroyed.
```

The command will create a KMS key and make changes and modify the S3 bucket. The changes to the S3 buckets are the lifecycle rules have been destroyed and a server side encryption has been configured.

Note: For `terraform apply` you will be required to approve the actions

## Step 6

Return to the terminal in which you are in feature_1. Once in the correct terminal run the following command:

```
terraform apply
```

When you run the `terraform apply` command, you terminal should look like this:

```
aws_kms_key.mykey: Refreshing state... [id=4f77fa38-23ca-4462-93e4-6dca26fca034]
aws_s3_bucket.TestBucket786: Refreshing state... [id=my-tf-test-bucket-786]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply":

 # aws_kms_key.mykey has changed
 ~ resource "aws_kms_key" "mykey" {
       id                                 = "4f77fa38-23ca-4462-93e4-6dca26fca034"
     + tags                               = {}
       # (12 unchanged attributes hidden)
   }


Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or respond to
these changes.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
 ~ update in-place
 - destroy

Terraform will perform the following actions:

 # aws_kms_key.mykey will be destroyed
 # (because aws_kms_key.mykey is not in configuration)
 - resource "aws_kms_key" "mykey" {
     - arn                                = "arn:aws:kms:eu-west-2:965403657359:key/4f77fa38-23ca-4462-93e4-6dca26fca034" -> null
     - bypass_policy_lockout_safety_check = false -> null
     - customer_master_key_spec           = "SYMMETRIC_DEFAULT" -> null
     - deletion_window_in_days            = 10 -> null
     - description                        = "This key is used to encrypt bucket objects" -> null
     - enable_key_rotation                = false -> null
     - id                                 = "4f77fa38-23ca-4462-93e4-6dca26fca034" -> null
     - is_enabled                         = true -> null
     - key_id                             = "4f77fa38-23ca-4462-93e4-6dca26fca034" -> null
     - key_usage                          = "ENCRYPT_DECRYPT" -> null
     - multi_region                       = false -> null
     - policy                             = jsonencode(
           {
             - Id        = "key-default-1"
             - Statement = [
                 - {
                     - Action    = "kms:*"
                     - Effect    = "Allow"
                     - Principal = {
                         - AWS = "arn:aws:iam::965403657359:root"
                       }
                     - Resource  = "*"
                     - Sid       = "Enable IAM User Permissions"
                   },
               ]
             - Version   = "2012-10-17"
           }
       ) -> null
     - tags                               = {} -> null
     - tags_all                           = {} -> null
   }

 # aws_s3_bucket.TestBucket786 will be updated in-place
 ~ resource "aws_s3_bucket" "TestBucket786" {
       id                          = "my-tf-test-bucket-786"
       tags                        = {
           "Environment" = "Dev"
           "Name"        = "My bucket"
       }
       # (10 unchanged attributes hidden)

     + lifecycle_rule {
         + enabled = true
         + prefix  = "config/"

         + noncurrent_version_expiration {
             + days = 90
           }

         + noncurrent_version_transition {
             + days          = 30
             + storage_class = "STANDARD_IA"
           }
         + noncurrent_version_transition {
             + days          = 60
             + storage_class = "GLACIER"
           }
       }

     - server_side_encryption_configuration {
         - rule {
             - bucket_key_enabled = false -> null

             - apply_server_side_encryption_by_default {
                 - kms_master_key_id = "arn:aws:kms:eu-west-2:965403657359:key/4f77fa38-23ca-4462-93e4-6dca26fca034" -> null
                 - sse_algorithm     = "aws:kms" -> null
               }
           }
       }

       # (1 unchanged block hidden)
   }

Plan: 0 to add, 1 to change, 1 to destroy.

Do you want to perform these actions?
 Terraform will perform the actions described above.
 Only 'yes' will be accepted to approve.

 Enter a value:
```

Once you have entered `yes`, your terminal should look like the following:

```
aws_kms_key.mykey: Destroying... [id=4f77fa38-23ca-4462-93e4-6dca26fca034]
aws_kms_key.mykey: Destruction complete after 0s
aws_s3_bucket.TestBucket786: Modifying... [id=my-tf-test-bucket-786]
aws_s3_bucket.TestBucket786: Modifications complete after 1s [id=my-tf-test-bucket-786]

Apply complete! Resources: 0 added, 1 changed, 1 destroyed.
```

The command will destroy the KMS key and make changes and modify the S3 bucket. The changes made to the S3 bucket are lifecycle rules have been added and the server side encryption has been destroyed.

Note: For `terraform apply` you will be required to approve the actions

## Explanation

As you saw, when you applied feature_1 and then applied feature_2, the changes made by feature_1 would be removed. The same would happen the other way round. This happened because terraform is declarative. It sees these versioning features which are not in the tf file and therefore deletes these to make the infrastructure match the code.

## Solution

The solution to this would be to have each branch correspond to an actual isolated environment.

It is even questionable whether you would want an environment per branch due to the large costs associated with environment creation. If you are working as part of a large team on a large environment, multiple environments will get very expensive very quickly. An alternative approach would be for long running trunk branches to have environments created for them and feature branches to work off these.

Additionally, all executions of Terraform must occur in a central CICD pipeline as this is the only way to ensure that the infrastructure is always in sync with the code. Additionally, it allows the environment to be written as code providing a stable environment.

# Appendix

## Appendix 1: Creating an S3 Backend.

In order to create the infrastructure for the S3 backend, the [nozaq/terraform-aws-s3-backend](https://github.com/nozaq/terraform-aws-remote-state-s3-backend) terraform module is recommended. Using this allows for the infrastructure to be created following all bet practices quickly and easily.

Use the `terraform show` command to show the outputs after creating the backend and get the correct variables for the s3 backend.
