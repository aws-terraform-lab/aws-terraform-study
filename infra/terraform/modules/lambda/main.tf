resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_${var.function_name}"

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

variable "function_name" {
  type = string
}

variable "image_uri" {
  type = string
}

variable "command" {
  type = list(string)
}

resource "aws_lambda_function" "test_lambda" {
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  image_uri     = var.image_uri
  package_type  = "Image"

  image_config {
    command = var.command
  }
  environment {
    variables = {
      foo = "bar"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.example,
  ]
}

output "invoke_arn" {
  value = aws_lambda_function.test_lambda.invoke_arn
}

output "arn" {
  value = aws_lambda_function.test_lambda.arn
}