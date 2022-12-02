# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}
variable "function_name" {
  description = "Function name of Lambda function"
  type        = string
  default     = ""
}