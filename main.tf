provider "aws" {
  region = var.aws_region
}

# resource "random_pet" "lambda_bucket_name" {
#   prefix = "backend-s3-terraform-aclavijo"
#   length = 4
# }

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "backend-s3-terraform-aclavijo"  
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

data "archive_file" "lambda_file" {
  type = "zip"

  source_dir = "${path.module}/lambda_java_example/"
  output_path  = "${path.module}/lambda_java_example/backend-app-aclavijo-terraform.zip"
}

resource "aws_s3_object" "lambda_file" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "backend-app-aclavijo-terraform.zip"
  source = data.archive_file.lambda_file.output_path

  etag = filemd5(data.archive_file.lambda_file.output_path)
}


resource "aws_lambda_function" "lambda_terraform" {
  function_name = var.function_name

  publish = false #new version if true, false default

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_file.key

  runtime = "java11"
  handler = "org.example.handlers.HandlerRequest"

  source_code_hash = data.archive_file.lambda_file.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
  
}

resource "aws_cloudwatch_log_group" "lambda_terraform" {
  name = "/aws/lambda/${aws_lambda_function.lambda_terraform.function_name}"

  retention_in_days = 3
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# resource "aws_lambda_alias" "lambda_alias" {
#   name             = "terraform java"
#   description      = "a terraform java code description"
#   function_name    = aws_lambda_function.lambda_terraform.arn
#   function_version = "1"
# }