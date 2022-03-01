terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# module "async_example" {
#   source = "./modules/sfn_async"
# }

module "lambda" {
  source = "./modules/lambda"
  
  function_name = "lambda-example"
  command = ["app.handler"]

  image_uri = "${module.ecr-lambdas.repository_url}:latest"
}

module "lambda-lock" {
  source = "./modules/lambda"
  
  function_name = "lock-job"
  command = ["app.handler"]

  image_uri = "${module.ecr-lambda-lock.repository_url}:latest"
}

module "lock-api" {
  source = "./modules/api_gateway"
  invoke_arn = "${module.lambda-lock.invoke_arn}"
  function_name = "lock-job"
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "jobs-state"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "JobId"
  range_key      = "State"

  attribute {
    name = "JobId"
    type = "S"
  }

  attribute {
    name = "State"
    type = "S"
  }
  tags = {
    Name        = "basic-dynamodb-table"
  }
}
