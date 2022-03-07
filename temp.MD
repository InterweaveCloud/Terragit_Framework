## Step 1 - Cloning a Repository

Using your file explorer, create a folder in which you would like to clone the repository in. Then using Visual Studio Code open the folder which you created by clicking on `File` at the top left corner of Visual Studio Code and then selecting `Open Folder ...`. Once you have opened the folder, click on `Terminal` at the top of Visual Studio Code then select `New Terminal`.

If you type in `ls` in the terminal you will see nothing will happen. This is because there are no files or folder in the folder you have created.

Copy and paste this into your browser:

```
https://github.com/DevOpsNavy/Terragit_Framework
```

This will take you to the repository that you will be cloning. You will see a small green box with `Code` written in it. Click on it and then select `SSH` and copy the SSH key . In the terminal type in the command `clone` followed by the SSH key you copied. Your terminal should look like the following:

```
Cloning into 'Terragit_Framework'...
remote: Enumerating objects: 1416, done.
remote: Counting objects: 100% (44/44), done.
remote: Compressing objects: 100% (19/19), done.
remote: Total 1416 (delta 28), reused 32 (delta 25), pack-reused 1372
Receiving objects: 100% (1416/1416), 143.84 KiB | 887.00 KiB/s, done.
Resolving deltas: 100% (815/815), done.
```

If you now type in `ls` into the terminal you will see `Terragit_Framework` in the terminal. This is the repository you have cloned and where you will find the exercise that you will be doing.
