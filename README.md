# simple-express-app
Basic Express.js web app used to demonstrate containerisation of a web app and deployment to AWS Elastic Container Registry (ECR).

## Pre-requisites
- Install [Docker for Mac](https://www.docker.com/docker-mac)
- Make the docker-task bash file executable by running: `chmod +x ./docker-task.sh`
- You have an existing AWS account and the [AWS CLI](https://aws.amazon.com/cli/) installed.

## Create ECR Repository
```
./docker-task.sh createrepo
```

This will create a new repository using the name of the Docker image (in this case it's `winterwindsoftware/simple-express-app`).
Note down the value of the `repositoryUri` field printed in the console.

You can then open the [ECR Console](https://console.aws.amazon.com/ecs/home#/repositories) to verify that is was created.

## Build Docker image
```
./docker-task.sh build
```

## Run container locally
```
./docker-task.sh run
```
Open a browser to http://localhost:9999/ and verify that "Hello world" is displayed.

## Deploy image to ECR
1. Open the `docker-task.sh` file and edit the `REPOSITORY_PATH` variable and set it to the path of your ECR. It should look something like `<aws_account_id>.dkr.ecr.<aws_region>.amazonaws.com`. It will be the first part of the `repositoryUri` value noted down in the CreateRepo step.
2. Save the file and then run `./docker-task.sh push`

This will upload your file to the ECS repository. You should be able to view it in the [AWS Console](https://console.aws.amazon.com/ecs/home#/repositories).

## Deploy CloudFormation Stack

```
aws cloudformation deploy \
    --stack-name SimpleExpressApp \
    --template-file ./cloudformation/ecs-webapp-stack.yml \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides KeyName=aws-ec2 \
    VpcId='vpc-56a0db32' \
    SubnetId='subnet-2aca635c,subnet-4e0bf764,subnet-6654943e,subnet-ce8c1ff3' \
    ContainerPort=8080 \
    DesiredCapacity=2 \
    EcsImageUri='856405715088.dkr.ecr.us-east-1.amazonaws.com/winterwindsoftware/simple-express-app' \
    EcsImageVersion='1.0.0' \
    InstanceType=t2.micro \
    MaxSize=3

```
