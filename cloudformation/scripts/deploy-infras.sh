#!/usr/bin/env bash

#Specify an argument to the script to override the environment
# dev:   ./deploy-api.sh db
# production (if nodejs):  ./deploy-api.sh production db
# stag:  ./deploy-api.sh stag db
ENV=${1:-dev}
TEMPLATE_NAME=${2}

NAME_SPACE=myapp
STACK_NAME=${NAME_SPACE}-${TEMPLATE_NAME}-${ENV}
PATH=infrastructures/
PROFILE_NAME=""
REGION=ap-southeast-1

aws cloudformation validate-template \
  --template-body file://infrastructures/${TEMPLATE_NAME}.yaml || exit 1

aws --profile ${PROFILE_NAME} --region ${REGION} cloudformation deploy \
  --template-file ${PATH}${TEMPLATE_NAME}.yaml \
  --stack-name "${STACK_NAME}" \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
  Environment="${ENV}" \
  Appname=${NAME_SPACE}
