resource "aws_lambda_function" "lambda" {
  filename         = "../build/distributions/java-terraform-1.0-SNAPSHOT.zip"
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  publish          = false
}

output "lambda_name" {
  value = aws_lambda_function.lambda.function_name
}