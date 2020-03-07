#!/usr/bin/env bash
#Specify an argument to the script to override the environment
# dev:   ./deploy.sh
# production:  ./deploy.sh prod
# stag:  ./deploy.sh stag
ENV=${1:-dev}

NAME_SPACE=myapp
ARTIFACTS_FOLDER=build
TEMPLATE_NAME=api
STACK_NAME=${NAME_SPACE}-${TEMPLATE_NAME}-${ENV}
PATH=infrastructures/
PROFILE_NAME=""
REGION=ap-southeast-1
BUCKET=${STACK_NAME}

#Build process in dev mode. You do not need to use a CI/CD pipeline for development
if [[ ${ENV} = dev ]]
then
    echo ${ENV}
    npm run build || exit 1
    npm run test:ci || exit 1
fi

# make the deployment bucket in case it doesn't exist
aws s3 mb s3://"${BUCKET}"

aws cloudformation validate-template \
  --template-body file://${PATH}${TEMPLATE_NAME}.yaml || exit 1

aws --profile ${PROFILE_NAME} --region ${REGION} cloudformation package \
  --template-file ${PATH}${TEMPLATE_NAME}.yaml \
  --output-template-file ${ARTIFACTS_FOLDER}/output.yaml \
  --s3-bucket "${BUCKET}"

#Load config. You must provide a config file if needed. See config.example.sh
source ./config.${ENV}.bash
source ./config.${ENV}.sh

# the actual deployment step
aws --profile ${PROFILE_NAME} --region ${REGION} cloudformation deploy \
  --template-file ${ARTIFACTS_FOLDER}/output.yaml \
  --stack-name "${STACK_NAME}" \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    Environment="${ENV}" \
    Appname=${NAME_SPACE}
