# Overview

This section acts as a "literature review" looking into how Terraform is implemented in CICD. We will explore several different approaches which are documented and review these against a set of selection criteria. Since many of the approaches are not comprehensively detailed, we will discuss their potential too. The selection criteria

# Selection Criteria

The selection and optimisation criteria for this exercise are as follows:

1. Scalability - the ability to handle multiple environments within a single repository with minimal overhead effort for extra environments. This is of upper importance to allow for the flexibility of the framework.
2. DRY - code is not repeated to support environments, code is reusable to support environments. Due to the tendency of large terraform codebases to be split into several smaller directories, it is important to to minimise the repetition of code.
3. KISS - code is not overly complex to support environments. Complex implementations can be difficult to maintain and understand.
4. Automation - maximum automation to prevent human error introduced during manual activities. It must be noted that there is the potential a TerraGit tool to be developed based on the framework developed so automation does take precedence over KISS.
5. Extensible - the ability to follow the framework with any CICD tool. Leveraging niche features specific to a CICD tool is disadvised.
6. Minimal Dependencies - Minimise the use of other tooling to maximise the amount of logic contained within Terraform.

# Hashicorp - Terraform Automation

## Advised Best Practices

[Hashicorp provide 4 tutorials on how to integrate Terraform with CICD for automation](https://learn.hashicorp.com/collections/terraform/automation)

The automated Terraform workflow advised is:

1. Initialize the Terraform working directory.
   `terraform init -input=false`
2. Produce a plan for changing resources to match the current configuration.

   `terraform plan -input=false -out=tfplan`

3. Have a human operator review that plan, to ensure it is acceptable.
   > Dependent on CICD tool.
4. Apply the changes described by the plan.
   `terraform apply -input=false tfplan`

A remote backend is mandatory for all CICD implementations.

The environment variable `TF_IN_AUTOMATION` must be set to a non empty value to indicate that the workflow is being executed in automation to slightly modify terraform outputs to suit terraform automation better.

If plan and apply are run on separate machines/containers (common when plan and apply occur in different steps), the entire working directory from the plan stage must be supplied to the apply stage at the same absolute path.

When a Terraform apply occurs, any other plans which were generated from the stale state must be invalidated.

Automated approval is desirable in development situations but manual approval is mandatory for production use-cases.

Pull requests should trigger a Terraform Plan to advise the acceptance of the pull request.

It is recommended to use a single backend for all environments with workspaces used to separate the environments.

The -backend-config option must used to specify the backend configuration if it is required to be dynamic.

# Terraform Workflows

## Hashicorp Workflows

When researching hashicorp workflows two articles draw particular attention.

https://www.hashicorp.com/blog/version-controlled-infrastructure-with-github-and-terraform

https://learn.hashicorp.com/tutorials/terraform/github-actions?in=terraform/automation

This two articles present the same workflow based on a feature branch methodology. Main has a long running environment and terraform plans occur on a pull request.

The methodology also utilises one single workflow with if statements to control what runs based on several variables.

## GitLab CI Workflows

https://about.gitlab.com/topics/gitops/gitlab-enables-infrastructure-as-code/

https://gitlab.com/gitops-demo/infra/templates/blob/master/terraform.gitlab-ci.yml

Looking at the GitLab CI workflows demonstrated, it is clear that the workflow is based on a feature branch methodology. Again only plans are generated on a pull request. Applies and therefore environments only exist on the main branch.
