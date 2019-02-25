#!/bin/bash
# Helper scripts for working with Docker image and container.

# Variables
IMAGE_NAME="winterwindsoftware/simple-express-app"
CONTAINER_NAME="simple-express-app_dev"
AWS_REGION=${AWS_REGION-us-east-1} # default to us-east-1
AWS_ACCOUNT=$(aws sts get-caller-identity --output text --query 'Account')
REPOSITORY_PATH="${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com"
FULLY_QUALIFIED_IMAGE_NAME="$REPOSITORY_PATH/$IMAGE_NAME"
HOST_PORT=9999
CONTAINER_PORT=8080

# Get version from package.json file so can tag the built image with version number.
# If you don't have node installed, you can just hardcode the version number here.
IMAGE_VERSION=`node -p "require('./package.json').version"`

# Builds the Docker image and tags it with latest version number.
buildImage () {
    echo Building Image Version: $IMAGE_VERSION ...
    docker build -t $IMAGE_NAME:latest -t $IMAGE_NAME:$IMAGE_VERSION ./
    echo Build complete.
}

# Runs the container locally.
runContainer () {
    docker run --rm \
        --name $CONTAINER_NAME \
        -p $HOST_PORT:$CONTAINER_PORT \
        -e "NODE_ENV=development" \
        -d $IMAGE_NAME
    echo Container started. Open browser at http://localhost:$HOST_PORT .
}

# Pushes the latest version of the image both with the `latest` and specific version tags
pushImage () {
    docker tag $IMAGE_NAME:latest $FULLY_QUALIFIED_IMAGE_NAME:latest
    docker tag $IMAGE_NAME:$IMAGE_VERSION $FULLY_QUALIFIED_IMAGE_NAME:$IMAGE_VERSION
    eval "$(aws ecr get-login --no-include-email --region $AWS_REGION)"
    docker push $FULLY_QUALIFIED_IMAGE_NAME:latest
    docker push $FULLY_QUALIFIED_IMAGE_NAME:$IMAGE_VERSION
}

createRepo () {
    aws ecr create-repository --repository-name $IMAGE_NAME
    echo Created ECR repository: $IMAGE_NAME.
}

# Shows the usage for the script.
showUsage () {
    echo "Description:"
    echo "    Builds, runs and pushes Docker image '$IMAGE_NAME'."
    echo ""
    echo "Options:"
    echo "    build: Builds a Docker image ('$IMAGE_NAME')."
    echo "    run: Runs a container based on an existing Docker image ('$IMAGE_NAME')."
    echo "    buildrun: Builds a Docker image and runs the container."
    echo "    createrepo: Creates new ECR repo called '$IMAGE_NAME'"
    echo "    push: Pushs the image '$IMAGE_NAME' to an image repository"
    echo ""
    echo "Example:"
    echo "    ./docker-task.sh build"
    echo ""
    echo "    This will:"
    echo "        Build a Docker image named $IMAGE_NAME."
}

if [ $# -eq 0 ]; then
  showUsage
else
  case "$1" in
      "build")
             buildImage
             ;;
      "run")
             runContainer
             ;;
      "buildpush")
             buildImage
             pushImage
             ;;
      "push")
             pushImage
             ;;
      "createrepo")
             createRepo
             ;;
      "buildrun")
             buildImage
             runContainer
             ;;
      *)
             showUsage
             ;;
  esac
fi
