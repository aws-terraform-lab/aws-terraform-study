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
  
  image_uri = "${module.ecr-lambdas.repository_url}:latest"
}

module "ecr-lambdas"  {
  source = "./modules/ecr"
  name = "lambda-images"
}