#!/bin/bash

#
# This script should be configured to run as a Jenkins job after each new build.
#
# This script depends on the following AWS environment variables. See Passwordstate or AWS IAM for details.
# AWS_DEFAULT_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
#

# Import AWS configuration variables
. ./config.sh

# Define local variables
AWS_ECR_TAG=$BUILD_ID

# Build and tag Docker image
docker build -t $AWS_ECR_REPOSITORY -t "$AWS_ECR_REPOSITORY:$AWS_ECR_TAG" .

# Push new Docker image to ECR tagged with current and latest builds
/usr/local/bin/ecs-cli push --registry-id $AWS_ACCOUNT_ID "$AWS_ECR_REPOSITORY:$AWS_ECR_TAG"
/usr/local/bin/ecs-cli push --registry-id $AWS_ACCOUNT_ID "$AWS_ECR_REPOSITORY:latest"

# Override default task definition compose configuration
cat <<EOT > docker-compose.override.yml
version: '3'
services:
  app:
    image: $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$AWS_ECR_REPOSITORY:$AWS_ECR_TAG
    volumes:
      - /usr/app
    logging:
      driver: awslogs
      options:
        awslogs-region: $AWS_DEFAULT_REGION
        awslogs-group: $AWS_ECR_REPOSITORY
        awslogs-stream-prefix: app
EOT

# Run ECS task definition with command
/usr/local/bin/ecs-cli compose --project-name $AWS_ECR_REPOSITORY --ecs-params ecs-params.yml --region $AWS_DEFAULT_REGION create --launch-type FARGATE

# Clean builds
docker rmi -f $(docker images --filter reference="$AWS_ECR_REPOSITORY:*$AWS_ECR_TAG*" -q)