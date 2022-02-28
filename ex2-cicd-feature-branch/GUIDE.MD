# The Need for a CICD Pipeline

## Introduction
In this tutorial, we will be demonstrating the need for a CICD pipeline when you build and deploy using Terraform. For this tutorial, you will need to have an AWS account, and I would recommend that you use Visual Studio Code while following this tutorial. You will also need your own GitHub account. 

## Step 1 - Forking the Repository
First you will need to fork the Terragit_Framework Repository. Copy and paste the following URL:
```
https://github.com/DevOpsNavy/Terragit_Framework
```
Once in the repository you will see a button with `Fork` written in it in the upper right section of you screen. Click on it and you will have forked the repository. You will know that you have done this correct as when you click on your profile symbol in the top right corner of GitHub and then select you repository, you will find the repository which you have forked. It should also say your username followed by `/Terragit_Framework` and underneath that it should say `forked from DevOpsNavy/Terragit_Framework`.

## Step 2 - Creating Action Secrets
Next, in GitHub you will need to create 4 action secrets with the following names:
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
S3_BACKEND_BUCKET
S3_BACKEND_KMS_KEY_ID
```

Here is how you make action secrets on GitHub. Navigate to your repository that you forked by click on your profile picture and selecting `My Repositories`. Then select the repository that you forked. Then once in the repository that you have forked, you will see a tab called `Settings` in the mid/upper right section of your screen. Then select that tab and then look to the left side of the screen and scroll down until you can see the security section. Under `Security` select `secrets` and then select `Actions`. 

In the upper right section of the screen you will find a tab with `New repository secret` written in there. For the name you put the name listed above and for value you should put the corresponding information. 

For AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY you should have already have these for the user that you was using in the pervious exercise. You should have saved it in a .CSV file. If you do no have this file or not saved this information anywhere you will need to create a new access key. To do this you will need to go to your AWS management console and use the service IAM. Once you are there, look to the left side of the screen and you will see under `Access Management` you will see `Users`, click on that. Then in the new search bar that popped up on your screen, enter the name of the user that you want to create a new access key for. Click on the user you are looking for. Click on the `Security Credentials` tab and scroll down until you reach the `Access keys` section. The make the old access key inactive by selecting `Make inactive` to the right of the access key. Then once that has been made inactive, select `Create access key`. Your new access key will be generated and a link from which you can download a .csv file containing you credentials on it. Download this file. Then with this information, proceed to create the action secret. 

For the S3_BACKEND_BUCKET and S3_BACKEND_KMS_KEY_ID you should be putting the same values that you used for the ex1. 

Your S3_BACKEND_BUCKET should look like the following with the blanks filled in:
```
terraform {
  backend "s3" {
    bucket     = ""
    key        = "ex.2/terraform.tfstate"
    region     = ""
    encrypt    = true
    kms_key_id = ""
    profile    = ""
  }
}

```

Your S3_BACKEND_KMS_KEY_ID should look like the following with the blanks filled in:
```
kms_key_id = ""
```

## Step 3 - Cloning the Repository 
Next you will be cloning the repository that you forked and added action secrets to. 

Using your file explorer, create a folder in which you would like to clone the repository in. Then using Visual Studio Code open the folder which you created by clicking on `File` at the top left corner of Visual Studio Code and then selecting `Open Folder ...`. Once you have opened the folder, click on `Terminal` at the top of Visual Studio Code then select `New Terminal`. 

If you type in `ls` in the terminal you will see nothing will happen. This is because there are no files or folder in the folder you have created. 

Now to clone the repository you will need a SSH key. You get this by clicking on the green button with code written in it. Then select SSH and copy the link. Then in your terminal type in `git clone` followed by a space and the paste the link you copied. Your terminal should look like the following if you enter this command:
```
Cloning into 'Terragit_Framework'...
remote: Enumerating objects: 833, done.
remote: Counting objects: 100% (261/261), done.
remote: Compressing objects: 100% (21/21), done.
remote: Total 833 (delta 252), reused 240 (delta 240), pack-reused 572
Receiving objects: 100% (833/833), 83.70 KiB | 591.00 KiB/s, done.
Resolving deltas: 100% (462/462), done.
```

Then if you type in `ls` you will find the files that were in the repository will be in the new folder that you made.

## Step 4 - Creating a New Branch
If you type in `git branch` into the terminal it will show you all of the branches. For now there is only one branch called `main`. If you type in `git status` it should show this in your terminal:
```
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```
It will tell you what branch you are currently working on and whether there is any work that is to be committed. 

You will be creating a a new branch called `ex2-main` and then will be pushing it to github. First, you will be creating a new branch. Copy the following code into your terminal:
```
git checkout -b ex2-main
```
Then press the enter key and your terminal should look like this:
```
Switched to a new branch 'ex2-main'
```

Then once your new branch has been made, to push your branch, copy and paste the following command:
```
git push origin ex2-main
```
Your terminal should look like the following:
```
To github.com:YourUsername/Terragit_Framework.git
 * [new branch]      ex2-main -> ex2-main
```

Repeat these steps again creating 2 more branches with the names `ex2-main-feature1` and the other called `ex2-main-feature2`.

## Step 5 - Add and Committing the Features
Now, you will be working in branches `ex2-main-feature1` and `ex2-main-feature2`. You will be adding different blocks of codes to the `main.tf` file in each branch. I would recommend that you just copy the code from feature 1 and feature 2 from the previous exercise.

Before making changes to the branch you need make sure that you are in the correct branch. Enter `git status` into the terminal and it should which branch you are in. You can also enter `git branch` where it will show all the branches and the one that is green and has a `*` is the branch you are working. 

If you are not in the correct branch enter `git checkout ex2-main-feature1` into the terminal, your terminal should show the following:
```
Switched to branch 'ex2-main-feature1'
```

Now that you are in the correct branch, in the `ex2-cicd-feature-branch` folder, open the `main.tf` file. Now you will need to add a block of code, I would recommend that you copy the code from ex1. If you are going to this, go to `ex1-tf_git_incompatibility` folder and then open the `feature_1` folder and copy the code from the `main.tf` file and paste it into the `main.tf` file of the `ex2-cicd-feature-branch` folder. 

Once you have added the code block to the `main.tf` you now will need to commit these changes to github. If you enter `git status` into your terminal it should look like the following:
```
On branch ex2-main-feature1
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   main.tf

no changes added to commit (use "git add" and/or "git commit -a")
```
`modified: main.tf` should be in red. 

Now what you should do is enter the following commands into the terminal:
```
git add main.tf
git status
```
After entering the commands, your terminal should look like the following:
```
On branch ex2-main-feature1
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   main.tf
```
`modified: main.tf` should be in green now. This means that your changes are ready to committed. In the terminal enter the command `git commit -m ""` but in the speech marks you will need to add a message to describe what changes have been in this commit. When you enter your command, your terminal should look similar to the following but with a few changes:
```
[ex2-main-feature1 7e0f5e4] Adding lifecycle rule to main.tf
 1 file changed, 25 insertions(+), 6 deletions(-)
```

Repeat the same steps in branch `ex2-main-feature2` copying the code from the `feature_2` folder.

## Step 6 - Pushing the Modified Branches
With branches modified and committed they now need to be pushed into the origin remote. This is similar to what what done in step 4. In the terminal enter the command:
```
git push origin ex2-main-feature1 
```
Your terminal should then look like the following but with a few minor changes:
```
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 2 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 611 bytes | 611.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:HasanDevOps2003/Terragit_Framework.git
   e78af7d..7e0f5e4  ex2-main-feature1 -> ex2-main-feature1
```

Repeat these steps but with the `ex2-main-feature2` branch.

## Step 7 - Merging
In this step you will be creating a pull request from `ex2-main-feature1` into the `ex2-main` branch and then merging `ex2-main-feature1` into the `ex2-main` branch. 

Now this is to be done in GitHub. If you navigate to the repository which you forked you will see that in yellow highlighted boxes with the name of the branches which you have just pushed, with how long ago the pushes were made written next to it. In that yellow box there should be another box but green with `Compare & pull request` written in it. For feature1 branch, click on the green box. You will be taken to a page where you will be creating the pull request. 

As mentioned before, you will be creating a pull request from `ex2-main-feature1` into the `ex2-main` branch so you will need to select the correct options. Under the title `Open a pull request` you will find a grey box. In that grey box, if there is another grey box with base repository written in it, make sure to click on that box and select the repository which you forked in the beginning. For the base select ex2-main and then create pull request. Then in your repository, navigate to the pull requests tab and scroll down. You will find your pull request, with a green tick in it with `All Checks Passed` written next to it. There should be an option to `Merge pull request` below. Choose that option and then confirm merge. A confirmation message will be displayed on your screen stating `Pull request successfully merged.

Repeat these steps again but merging `ex2-main-feature2` in to `ex2-main`. 

## Explanation
For feature 1 and 2, because they were in different branches, they had different workflows. To work around this problem, the 2 developed features were made, committed to a repository and merged into main branch with the help of a CICD block.

The planned destroy was just noise due to the feature 2 branch being stale compared to ex2-main. This can be avoided by keeping the feature branch up to date with the trunk branch. Due to this the following workflow is recommended to reduce noise (for feature 2):
```
git checkout ex2-main 
git pull origin 
ex2-main git checkout ex2-main-feature2 
git merge ex2-main 
git push origin ex2-main-feature2
```
It is recommended this is scripted for consistency.