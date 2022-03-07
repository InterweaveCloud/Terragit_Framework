# Old

This exercise aims to demonstrate the use of Terraform with Github Actions to automate the deployment of a feature environments with CICD.

To begin with, fork the repository and open it locally using git.

Then you must add the following secrets to the github repo:

Secrets:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

Config for S3 Backend
S3_BACKEND_BUCKET:
S3_BACKEND_KMS_KEY_ID:

To begin with, you must create a branch called "ex3-main" and push this up to the repo.

Once you have pushed this up to the remote repo, this should trigger a the terraform exercise 3 workflow to run and to create the main feature environmment.

It will create a bucket preprended with the branch name.

Now imagine you have two new features to add, one being adding a second s3 bucket and another adding a kms key.

Create two new branches off ex3-main called ex3-add-kms and ex3-add-s3, and push this to the remote repo. Against you will see two new bucket created prepended with the branch name, so you now have three buckets total.

git checkout ex3-main
git checkout -b ex3-add-kms
git push origin ex3-add-kms

git checkout ex3-main
git checkout -b ex3-add-s3
git push origin ex3-add-s3

From this, it is clear that branches now each have their own environment. Key to enabling this is ensuring namespaces do not overlap. Where namespaces such as s3 are globally scoped or account scoped, the branch variable is used to differentiate the resources created for each feature branch.

Looking at variables.tf you can see the branch variable is detected from the environment. Within main.tf you can see var.branch is used within the s3 bucket name as this is a global namespace shared across users.

Within the support_scripts/set-branch-env-var.sh, you can see the TF_VAR_branch is set to the branch name. Additionally, it grabs this information from different sources of the github event, adapting to where the information is (if it is a pull, merge, delete event etc).

Create a pull request for each branch to be merged into ex3-guide.

Notice how in each pull request a plan is generated and added to the comments. This plan is taken from the perspective of the target branch and will actually show what is would actually be executed if the pull request was merged.

Once each is merged in, you will notice a workflow is triggered which creates the infrastructure

Delete the branches once complete. Once each branch is deleted, another workflow is triggered which deletes the infrastructure.

# New CICD Feature

## Introduction

In this tutorial, we will be demonstrating the need for a CICD pipeline when you build and deploy using Terraform. For this tutorial, you will need to have an AWS account, and I would recommend that you use Visual Studio Code while following this tutorial. You will also need your own GitHub account.

Before beginning, you will need to do Step 1, 2 & 3 from ex2's guide where you will need to fork the `Terragit_Framework`, add action secrets to it and then clone that repository. Once you have done this you can begin with this tutorial.

## Step 1 - Creating a Main Branch

First you will need to create a new branch. You will need to open a new terminal but clicking on the `Terminal` tab at the top left of Visual Studio Code and select `New Terminal`. In the terminal navigate to the ex3-cicd-feature-env using the `cd` command.

If you enter `git branch` you should see all the branches in the repository. There should be a branch named main and the branches from the previous exercise if you have left them there. Similar to the previous branch you will be making a new branch called `ex3-main`. To do this enter the following command into your terminal:

```
git checkout -b ex3-main
```

Your new branch should be made and your terminal should display the following:

```
Switched to a new branch 'ex3-main'
```

If you inter the `git branch` command you will now see the branches from before there along with the new branch that you made. Now that your branch has been created you can now push the newly created branch into the repository. Copy and paste the following command into your terminal:

```
git push origin ex3-main
```

Your terminal should then look like the following:

```
Total 0 (delta 0), reused 0 (delta 0)
remote:
remote: Create a pull request for 'ex3-main' on GitHub by visiting:
remote:      https://github.com/HasanDevOps2003/Terragit_Framework/pull/new/ex3-main
remote:
To github.com:HasanDevOps2003/Terragit_Framework.git
 * [new branch]      ex3-main -> ex3-main
```

You can double check that your push has been done by going into your repository that you forked and clicking onto the branches tab.

# Step 2 - Creating Feature 1 & Feature 2

Now you will be creating 2 branches, called `ex3-main-feature-1` and `ex3-main-feature-2` with each branch containing different infrastructure. Now first you need to create the branches so you will need to enter the following commands to create the 2 new branches:

```
git checkout -b ex3-main-feature-1
git checkout -b ex3-main-feature-2
```

If you enter the command `git status`, you will be told what branch you are working on. As `ex3-main-feature-1` should be the most recent branch you made your terminal should display the following when you enter the `git status` command:

```
On branch ex3-main-feature-2
nothing to commit, working tree clean
```

Now with the branches made, you now need to add infrastructure to the branches. First you will need to navigate to `ex3-main-feature-1` branch. To do this you need to enter the following command into your terminal:

```
git checkout ex3-main-feature-1
```

Your terminal should then display the following:

```
Switched to branch 'ex3-main-feature-1'
```

To double check that you have navigated to the correct branch enter the `git status` command, your terminal should display the following:

```
On branch ex3-main-feature-1
nothing to commit, working tree clean
```

You need to add infrastructure into the `main.tf` of this branch, I would recommend that you copy the infrastructure from the `main.tf` from `feature_1` folder. Once you have added in the infrastructure save the file. Then in your terminal enter in `git status`, your terminal should display the following:

```
On branch ex3-main-feature-1
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   main.tf

no changes added to commit (use "git add" and/or "git commit -a")
```

As of yet, there is nothing to be committed however changes have been made, to have your changes committed you will need to do as it says and use the command `git add` and then the name of the file that has been modified with changes that you want committed. So in the terminal do as it says and enter `git add main.tf` into the terminal. Nothing will pop up in your terminal but if you enter `git status`, your terminal should look different to the last time you entered the `git status` command:

```
On branch ex3-main-feature-1
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   main.tf

```

You will notice that there are changes that are to be committed and the text `modified: main.tf` is now green oppose to being red. Your changes are now ready to be committed so you can enter the `git commit -m ""` command but in the speech marks you should leave a message saying what changes that you have made. When i did this myself I added a lifecycle rule to infrastructure so i made the comment "Lifecycle rule added to bucket". Once you enter this into the terminal, your terminal should look similar to what is to follow but with your message written:

```
[ex3-main-feature-1 0c90331] Lifecycle rule added to bucket
 1 file changed, 18 insertions(+)
```

With your changes commited you need to now push your branch into remote. To do this enter the command `git push origin ex3-main-feature-1`. Your terminal should look like the following:

```
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 2 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 642 bytes | 642.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
remote:
remote: Create a pull request for 'ex3-main-feature-1' on GitHub by visiting:
remote:      https://github.com/HasanDevOps2003/Terragit_Framework/pull/new/ex3-main-feature-1
remote:
To github.com:HasanDevOps2003/Terragit_Framework.git
 * [new branch]      ex3-main-feature-1 -> ex3-main-feature-1
```

Now you must repeat this process again but this time in `ex3-main-feature-2` branch.

## Step 3 - Creating a Pull Request and Merging

To do a pull request, you will need to do it in GitHub. In GitHub navigate to the repository in which you forked and click onto the `Pull requests` tab and you will find on the right side of the screen a green box with the text `New pull request` written into it. You will need to select the repository in which you want to compare changes. The repository you will need to select is the repository which you forked. Then for your base branch you will select the `ex3-main` branch and for the compare branch select `ex3-main-feature-1` and then select `Create pull request`. You will then be taken to a new tab where it will say `All checks successful` and you will be able to click on the `Merge pull request` button and then `Confirm merge`. You can go to the `Actions` tab and see the workflow that will be done in your branch.

## Conclusion and Explanation

Finally, when the branch is deleted in the remote repo, this will execute a terraform destroy (as lon as the branch starts with ex3), this is to clean up the infrastructure when a feature branch is complete. By doing this, you can merge the branch in which you created a feature into a main branch will posses all the infrastructure worked on by a group of developers. When working it is good practice to enter the command `git pull origin main` so that you have the most latest version of the main branch.
