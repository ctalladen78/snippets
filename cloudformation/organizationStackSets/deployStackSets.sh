#!/usr/bin/env bash

GLOBAL_STACK_NAME=waves-organization
MASTER_ACCOUNT_ID=""
DEV_ACCOUNT_ID=""
PROD_ACCOUNT_ID=""
REGION=ap-southeast-1

aws cloudformation update-stack-set \
    --stack-set-name ${GLOBAL_STACK_NAME} \
    --template-body file://organizationsSetup.yaml \
    --region ${REGION} \
    --capabilities=CAPABILITY_NAMED_IAM

aws cloudformation update-stack-instances \
    --stack-set-name ${GLOBAL_STACK_NAME} \
    --regions ${REGION} \
    --accounts "${MASTER_ACCOUNT_ID}" "${PROD_ACCOUNT_ID}" "${DEV_ACCOUNT_ID}" \
    --operation-preferences MaxConcurrentPercentage=50

