## Before running

Set the following environment variables:

AWS_S3_ACCESS_KEY_ID
AWS_S3_SECRET_ACCESS_KEY

## What it does

The script goes through every file inside `git`, `feed` or `build` and uploads all of them to aws to the corresponding directories in the `unity` top folder. Therefore, it is **VERY IMPORTANT** that these directories only have the files to be uploaded and **NOTHING ELSE** (`.gitignore` files are skipped)

## Uploading a build - `build` directory

1. Delete all unwanted files that are in `build/` by runnning `git lfs -f` inside it
2. Copy the unitypackage file to `build/unity/releases`
3. Run `script/upload-build` with no arguments to see what it will do
4. Run `script/upload-build go` to upload all the files in `build/`

## Uploading the update feed for releases - `feed` directory

1. Delete all unwanted files that are in `feed/` by runnning `git lfs -f` inside it
2. Copy the `latest.json` file to `feed/unity`
3. Run `script/upload-feed` with no arguments to see what it will do
4. Run `script/upload-feed go` to upload all the files in `feed/` (in this case, only one)

## Uploading git and git-lfs - `git` directory

1. Delete all unwanted files that are in `git/` by runnning `git lfs -f` inside it
2. Copy the git.zip/git.json and git-lfs.zip/git-lfs.json file pairs to the correct platform directory (`git/unity/git/windows`, `git/unity/git/mac`, `git/unity/git/linux`). Only the files that have been changed need to be uploaded.
3. Run `script/upload-git` with no arguments to see what it will do
4. Run `script/upload-git go` to upload all the files in `git/`
