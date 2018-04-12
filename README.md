# simple-express-app
Basic Express.js web app used to demonstrate containerisation of a web app and deployment to AWS Elastic Container Registry (ECR).

## Pre-requisites
- Install Docker for Mac
- Make our docker scripts file executable by running: `chmod +x ./docker-task.sh`
- AWS account exists and a repository has been created in [ECR](https://console.aws.amazon.com/ecs/home#/repositories).

## Build Docker Image
```
./docker-task.sh build
```

## Run container locally
```
./docker-task.sh run
```
Open a browser to http://localhost:9999/ and verify that "Hello world" is displayed.

## Deploy image to ECR
1. Open the `docker-task.sh` file and edit the `REPOSITORY_PATH` variable and set it to the path of your ECR. It should look something like `<aws_account_id>.dkr.ecr.<aws_region>.amazonaws.com`.
2. Save the file and then run `./docker-task.sh push`

This will upload your file to the ECS repository. You should be able to view it in the [AWS Console](https://console.aws.amazon.com/ecs/home#/repositories).

