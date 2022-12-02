#!/bin/bash
FUNCTION_NAME=$1
ALIAS_NAME="Terraform_alias"
VERSION_NUMBER="1"

#aws lambda publish-version --function-name $FUNCTION_NAME --description "updated via cli" --profile default | jq '.Version'  

#aws lambda create-alias --function-name $FUNCTION_NAME --name $ALIAS_NAME --function-version $VERSION_NUMBER --profile default

#aws lambda update-alias --function-name $FUNCTION_NAME --name $ALIAS_NAME --version $VERSION_NUMBER --description "a terraform update"--profile default
aws lambda delete-alias --function-name $FUNCTION_NAME --name $ALIAS_NAME --function-version $VERSION_NUMBER --profile default
echo "done"

# run command example: sh lambda_publish_Latest_NewVersion.sh backend-app-aclavijo-terraform