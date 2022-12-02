provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_role" {
  name               = "basic_lambda_cavs_role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {

  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   },
   {
     "Effect": "Allow",
     "Action": [
       "s3:*",
       "s3-object-lambda:*"
     ],
     "Resource": "*"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename         = "../build/distributions/springboot-aws-s3-example-1.0-SNAPSHOT.zip"
  function_name    = "basic-lambda-cavs"
  role             = aws_iam_role.lambda_role.arn
  handler          = "org.example.handlers.HandlerRequest"
  runtime          = "java11"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  publish          = false
}

output "lambda_version" {
  value = aws_lambda_function.terraform_lambda_func.version
}


output "lambda_name" {
  value = aws_lambda_function.terraform_lambda_func.function_name
}

