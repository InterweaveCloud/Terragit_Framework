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

## Feature Branch Methodology Notes

The feature branch methodology while a step in the right direction, does still have some fundamental flaws.

Terraform plans are not as fool proof as terraform applies. IAM permissions very commonly fail on terraform applies due to malformed policies. Additionally, testing on these feature branches is not possible due to no apply, risking large amounts of pull requests being created to test code. This is also a laborious process and development is often an interative process where changes are made and then manual/automated tests run to ensure the code is working as expected.

These methdologies present minimal guidance on how multiple environments can be managed e.g dev, test, prod environments. This is a huge flaw and leaves a large requirement for developers to repeatedly and independently devise solutions to the plethora of complexities and nuances that do arise.

## GruntWork Workflow

Grunt work present a new workflow for managing multiple environments within a CICD workflow. GruntWork is a leading figure within the Terraform ecospace.

https://blog.gruntwork.io/a-comprehensive-guide-to-terraform-b3d32832baca#.b6sun4nkn

https://blog.gruntwork.io/how-to-use-terraform-as-a-team-251bc1104973

We will be looking specifically at their guide on how to use terraform as a team.

It is highlighted how deployment should occur on a CI server as this provides full automation - preventing manual error and ensuring deployment is fast and repeatable. Also it ensures that a consistent enviuronment is always used with the environment itself versioned as code. Finally, it makes it a lot easier to manage permissions for environments and enforce good security practices - dozens of developers no longer need individual permissions.

### Live Repo and Module Repo

It is recommended that a modules repo is used to house the reuseable modules while the live repo is used to call these modules to create the dev,test,prod environments.

### Key Rules

- Only terraform should be used to manage the infrastructure and no out of band tools should be used to make changes like CLI, portal. This maximises the benefit of IAC.

- Each environment should have its own folder, each component should be in its own folder

- Changes to the production environment should only be executed through the main branch.

### Workflow

The workflow here is genuinely explained in a highly convoluted manner and it is not entirely clear whether the following is how it is intended to be used however the current understanding is:

On the main branch a folder per environment exists: Dev, test, prod.

If changes are need to be made to the dev environment, changes are made directly onto the main branch in the dev environment folder. The changes should not be much more than changing module versions and a few variables since the modules will contain the bulk of the changes.

Once this confirmed to be working, the same is done to test and prod all on the main branch.

The idea of not using git branching at all seems absolutely ludicrous and I am not entirely sure if I have misunderstood the article but it does clearly state not to use branches. It appears to have given up on the challenges that git branching poses and opted to betray DRY and use multiple folders.

It does suggest the use of Terragrunt to bypass this issue and minimise the reuse of code. However. While this article presents a huge amount of good advice, my current understanding boggles my mind and I am struggling to analyse the workflow due to this.

Other arguments presented around using multiple folders involve the poor legibility of conditionals to manipulate across environments however there are better ways to adapt the configuration of environments.

I have read this article about a dozen times now start to finish and to this day I am still dumbfounded and hope one day to understand this a lot better and hope that it does not suggest what I believe it suggests.

Terragrunt is proposed as a tool to deal with this MASSIVE scale of duplication however it does not do this very well at all!

" This way, each module in each environment is defined by a single terragrunt.hcl file that solely specifies the Terraform module to deploy and the input variables specific to that environment. This is about as DRY as you can get! "

So basically, for each environment, a separate block of code and variables is required for each module. This does not scale well at all for large numbers of environments.

https://www.codurance.com/publications/2020/04/28/terraform-with-multiple-environments

Solutions like the above use multiple folders and symlink across folders to minimise code reuse.

## Terraform Workspaces

https://getbetterdevops.io/terraform-create-infrastructure-in-multiple-environments/

Utilising terraform workspaces is presented as a good way to manage multiple environments. While the existing information does not provide much information on integration of workspaces with CICD, it does provide good examples of how to manipulate the variables provided to terraform utilising the workspace var.

However, the advice around how to thoroughly manipulate infrastructure between environments is not clear.

## Workflow Conclusion

Overall, there does not seem to be a clear path forward. Solutions seem to fall under two main bands - multiple directories and workspaces. With industry giant gruntwork and other sources advocating for multiple directories, the amount of code repeated is absolutely ridiculous with poor scalability for new environments. From previous experience spinning up new environments as isolated failure domains was common, be it for interfacing with teams allowing them to practice on our up and coming tool in a safe sandbox environment, creating a stable environment for demos, or simply creating an environment just to try some super destructive test features/code on! This betrayal of DRY and lack of scalability makes this structure completely infeasible.

Where automated workflows for Terraform have been presented, these attempt to leverage a feature branch methodology with some band aids, such as terraform applies only on pull requests. However, these fail to specify how multiple environments can be supported and do not really provide a comprehensive framework. This Terragit framework will attempt to overcome these shortcomings and provide a framework that is more scalable and implementing better coding practices.

# Branching

With branching with terraform, the three main camps appear to be advocates for trunk branching only with no feature branching, feature branches which only execute plans or feature environments.

https://blog.zhenkai.xyz/the-best-git-branching-strategy-for-terraform-is-no-branching/

The above article perfectly summarises the problem with feature branches with terraform in the traditional sense and attempts to resolve the issue simply by having no feature branches at all. It does not touch on how environments can be managed between dev, test, prod environments.

The github actions and GitlabCI and terraform enterprise tutorials present a paradigm where plans will only occur on pull requests from feature branches to environment branches. However, being able to do plans only on pulls provides minimal benefit and adds a a lot of overhead to testing any small iterative change.

https://acidtango.com/thelemoncrunch/how-to-deploy-multiple-branches-with-terraform-and-github-actions/

https://hackernoon.com/from-feature-branches-to-feature-environments-with-terraform-10973ycb

The two articles above present a new paradigm of feature branches.

“The advantage of feature branching is that each developer can work on their own feature and be isolated from changes going on elsewhere.” (FeatureBranch)

This allows the use of git again in its most traditional way where each branch including feature branch corresponds to its own isolated failure domain yet again.

At the core of the feature environment is the ability to pick up a variable which detects the branch the environment is on and then sets the correct variables based on the branch.

The key concerns around this really are around cost so dynamic infrastructure across environments will be very important.

# Terraform Up ands Running - Second Edition

The aim of this section is to review the Terraform up and running Second Edition book and review how this can be converted into a set of repeatable requirements for the Terragit framework.
