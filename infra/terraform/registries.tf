
module "ecr-lambdas"  {
  source = "./modules/ecr"
  name = "lambda-images"
}

module "ecr-lambda-lock"  {
  source = "./modules/ecr"
  name = "lambda-lock"
}

