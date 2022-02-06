Git and Terraform are incompatible.

This is due to that the git paradigm of an isolated environment per branch is not natively supported by Terraform.

This is demonstrated in the following example:

Pre Steps:

In all three folders copy and paste Backend.tmpl into backend.tf and replace the variables with your values. You must use a remote s3 backend as this is the bare minimum to be able to collaborate with other users.

Do a terraform apply within the main folder. Notice how a simple s3 bucket has been created. Now lets imagine you and another developer have been assigned two different features.

You have been assigned feature 1 - Add versioning and lifecycle rules to the s3 bucket.

And another developer has been assigned feature 2 - add server side encryption to the s3 bucket using KMS.

Lets say you have been developing feature 1 and have added your code, do a terraform apply in feature_1 folder.

Notice how your code has successfully executed.

Now say the second developer on feature_2 has added his code. Do a terraform apply in feature_2 folder.

Notice how his feature has successfully been implemented however it also destroyed your KMS resource and encryption settings.

This is because his code does not contain your feature 1 code. Because terraform is declarative, it sees these versioning features which are not in the tf file and therefore deletes these to make the infrastructure match the code.

If you do another terraform apply in feature_1 folder, you will see that your versioning and lifecycle rules are back but the KMS resource and settings are gone.

Working on terraform using branches is a pain as each branch is no longer an isolated environment and you will often step on the toes of another developers.

The solution to this would be to have each branch correspond to an actual isolated environment.

It is even questionable whether you would want an environment per branch due to the large costs associated with environment creation. If you are working as part of a large team on a large environment, multiple environments will get very expensive very quickly. An alternative approach would be for long running trunk branches to have environments created for them and feature branches to work off these.

Additionally, all executions of Terraform must occur in a central CICD pipeline as this is the only way to ensure that the infrastructure is always in sync with the code. Additionally, it allows the environment to be written as code providing a stable environment.
