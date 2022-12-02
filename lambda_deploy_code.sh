#!/bin/bash
NAME=$1
cd ./lambda_new_versions/

zip -r $NAME.zip handler.java 
aws lambda update-function-code --function-name $NAME --zip-file fileb://$NAME.zip --no-cli-pager --profile default 
aws lambda publish-version --function-name $NAME --description "update via cli" --profile default | jq '.Version'  
echo "done"

# run command example: sh lambda_deploy_code.sh backend-app-aclavijo-terraform