# The incompatibility of Git and Terraform

## Introduction
Git and terraform are not compatible, the reason being that the git paradigm of an isolate environment per branch is not natively supported by Terraform. In this exercise, you will be following a set of step which will help identify the challenges faced and have them explained as well.

## Setting the Scenario
Before you begin, I would like to make you aware of the scenario that will be simulated in the steps that follow.

Yourself and a colleague are to work on features for an S3 bucket. You will be working on feature 1. which adds versioning and lifecycle rules to the S3 bucket. Your colleague will be working on feature 2, which adds server side encryption to the S3 bucket using KMS.

## Step 1
For each folder (main, feature_1 and feature_2) copy Backend.tmpl into a file called backend.tf and replace the variables with your own values.

## Step 2
Navigate to the main folder in terminal using the `cd` command. You can check which folder you are in using the `ls` command. Once in the main folder run the following commands in the order it is written in:
```
terraform init
terraform apply
```

The commands will initialize the backend and create the S3 bucket.

Note: For `terraform apply` you will be required to approve the actions

## Step 3
In a  new terminal, navigate to the feature_1 folder using the `cd` command. You can check which folder you are in using the `ls` command. Once in the feature_1 folder run the following command:
```
terraform apply
```

The command will make changes and modify S3 bucket. The changes are it will add lifecycle rules and enable versioning

Note: For `terraform apply` you will be required to approve the actions

## Step 4
In a  new terminal, navigate to the feature_2 folder using the `cd` command. You can check which folder you are in using the `ls` command. Once in the feature_2 folder run the following command:
```
terraform apply
```

The command will create a KMS key and make changes and modify the S3 bucket. The changes to the S3 buckets are the lifecycle rules have been destroyed and a server side encryption has been configured.

Note: For `terraform apply` you will be required to approve the actions

## Step 5
Return to the terminal in which you are in feature_1. Once in the correct terminal run the following command:
```
terraform apply
```

The command will destroy the KMS key and make changes and modify the S3 bucket. The changes made to the S3 bucket are lifecycle rules have been added and the server side encryption has been destroyed.

Note: For `terraform apply` you will be required to approve the actions

## Explanation
As you saw, when you applied feature_1 and then applied feature_2, the changes made by feature_1 would be removed. The same would happen the other way round. This happened because terraform is declarative. It sees these versioning features which are not in the tf file and therefore deletes these to make the infrastructure match the code. 

## Solution
The solution to this would be to have each branch correspond to an actual isolated environment.

It is even questionable whether you would want an environment per branch due to the large costs associated with environment creation. If you are working as part of a large team on a large environment, multiple environments will get very expensive very quickly. An alternative approach would be for long running trunk branches to have environments created for them and feature branches to work off these.

Additionally, all executions of Terraform must occur in a central CICD pipeline as this is the only way to ensure that the infrastructure is always in sync with the code. Additionally, it allows the environment to be written as code providing a stable environment.