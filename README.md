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
Open your terminal and run the CLI command below to create your stack. Before running it, you will need to update all values surrounded by angle brackets, e.g. (`<your_vpc_id>`).

```
aws cloudformation deploy \
    --stack-name SimpleExpressApp \
    --template-file ./cloudformation/ecs-webapp-stack.yml \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides KeyName='<your_keypair_id>' \
    VpcId='<your_vpc_id>' \
    SubnetId='<your_subnet_id_1>,<your_subnet_id_2>' \
    ContainerPort=8080 \
    DesiredCapacity=2 \
    EcsImageUri='<your_ecr_image_uri>' \
    EcsImageVersion='<your_app_version_number>' \
    InstanceType=t2.micro \
    MaxSize=3
```
