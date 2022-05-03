# Creating an S3 Backend    

## Introduction
During the exercises in this registry you will need to have an S3 Backend configured. If you already have one you can bypass this but forn those who do not have one, this will be an in depth guide on how to make an S3 Backend using the [nozaq](https://registry.terraform.io/namespaces/nozaq) / [remote-state-s3-backend](https://registry.terraform.io/modules/nozaq/remote-state-s3-backend/aws/latest) module.

## Prequisites
In order to create an S3 Backend you will need the following software:
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

And you will need the following accounts:
- AWS

## Step 0.1 - Navigation
This is a guide to show those who are new to powershell how to navigate to different folders using the terminal. In the terminal if you input `ls` and a directory will be shown to display which folder you are currectnly in and the folders and files saved within the folder you are currently in. To navigate to a folder input `cd` followed by a space and then the name of the folder you would like to navigate into.

## Step 1 - Inputting Credentials
First you will need your access key for your account, if you have your key then you can skip this paragraph but for those who do not this is how you generate new access keys. In your AWS console open the `IAM` service. In the `IAM` navigate to `Users` and find the user whcih you would like to generate new access keys for. Then select `Security Credentials` and scroll down to the `Access keys` section. From there you should be able to select `Create access key` and a new access key will be created, then select `Download .csv file`. It is important that you do this because once you close the window that was opened you will not be able to see your access key again unless you have downloaded it. Now that you have your access key you are ready to input them. 

Open a terminal and input `AWS configure` and input the correct credentials when promted. Once you have done this you will be ready to begin using the module.

## Step 2 - Creating Resources
To create the resources all you will need to do is input `terraform init` and once it says backend initialized you can then input `terraform` apply and `yes` when prompted. 

## Step 3 - Inputting into backend.tf
Now with everthing created you will need to input the name of the bucket, dynamoDB table and kms key into the the `backend.tf`. These can be found in the terminal or you can use certain commands to display resources for you.

To find the name of the DynamoDB table input into the terminal:
 `terraform state show module.remote_state.aws_dynamodb_table.lock`
 You will be able to find the name of the DynamoDB table

 To find the name of the name of the bucket input into the terminal:
 `terraform state show module.remote_state.aws_s3_bucket.state`
 You will be able to find the name of the bucket

 To find the kms key id input into the terminal:
 `terraform state show module.remote_state.aws_kms_key.this`
 You will be able to find the kms key id.

## Conclusion
Now you have created the resources needed to create a `backend.tf`. You are now prepared to do the exercises in this registry.
