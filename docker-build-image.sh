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
/usr/local/bin/ecs-cli push --registry-id $AWS_ACCOUNT_ID $AWS_ECR_REPOSITORY