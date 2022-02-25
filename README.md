# aws-terraform-study

Create a file named `aws_config.tf` in root and put your aws credentials, otherwise privide this one by environment

```terraform
provider "aws" {
  region = "us-east-1"
  access_key = "access_key"
  secret_key = "secret_key"
}
```