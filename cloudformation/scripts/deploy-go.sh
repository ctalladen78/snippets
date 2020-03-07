#!/usr/bin/env bash

#Specify an argument to the script to ovveride the environment
# dev:   ./deploy.sh
# prod:  ./deploy.sh production
# stag:  ./deploy.sh staging
ENV=development
NAME_SPACE=myapp
ARTIFACTS_FOLDER=bin
TEMPLATE_NAME=api
STACK_NAME=${NAME_SPACE}-${TEMPLATE_NAME}-${ENV}
PATH=infrastructures/
PROFILE_NAME=""
REGION=ap-southeast-1
BUCKET=${STACK_NAME}

#Build and testing process
go mod vendor
make build || exit 1
make test || exit 1

# make the deployment bucket in case it doesn't exist
aws s3 mb s3://"${BUCKET}"

aws cloudformation validate-template \
  --template-body file://${PATH}${TEMPLATE_NAME}.yaml || exit 1

aws --profile ${PROFILE_NAME} --region ${REGION} cloudformation package \
  --template-file ${PATH}${TEMPLATE_NAME}.yaml \
  --output-template-file output.yaml \
  --s3-bucket "${BUCKET}"

# the actual deployment step
aws --profile ${PROFILE_NAME} --region ${REGION} cloudformation deploy \
  --template-file output.yaml \
  --stack-name "${STACK_NAME}" \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
  Environment="$ENV" \
  Appname=${NAME_SPACE}
