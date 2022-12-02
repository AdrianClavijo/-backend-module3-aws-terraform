#!/bin/bash
OUTPUT=$1
mkdir -p lambda_functions

download_code () {
        aws lambda get-function --function-name $OUTPUT --query 'Code.Location' --profile default | xargs wget -O ./lambda_functions/$OUTPUT.zip
        unzip ./lambda_functions/$OUTPUT.zip -d ./lambda_functions
        rm ./lambda_functions/$OUTPUT.zip
}
if [ -z "$(ls -A ./lambda_functions)" ];
then
      download_code
else
      echo "already exists"
fi

echo "done"

# run command example: sh lambda_download_code.sh backend-app-aclavijo-terraform