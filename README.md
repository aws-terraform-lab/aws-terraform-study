# aws-terraform-study

Create a file named `aws_config.tf` in root and put your aws credentials, otherwise provide this one by environment

```terraform
provider "aws" {
  region = "us-east-1"
  access_key = "access_key"
  secret_key = "secret_key"
}
```

ou create a .env file in root dir with aws ENV vars
```shell
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=access_key
AWS_SECRET_ACCESS_KEY=secret_key
```
