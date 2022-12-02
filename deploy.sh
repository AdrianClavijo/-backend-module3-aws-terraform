#!/bin/bash
set -eo pipefail
ARTIFACT_BUCKET='rencinas-bucket2'
TEMPLATE=template.yml
AWS_PROFILE=$1

aws cloudformation package --template-file $TEMPLATE --s3-bucket $ARTIFACT_BUCKET --output-template-file out.yml --profile $AWS_PROFILE
aws cloudformation deploy --template-file out.yml --stack-name java-basic --capabilities CAPABILITY_NAMED_IAM --profile $AWS_PROFILE
