
module "step_function" {
  source = "terraform-aws-modules/step-functions/aws"

  name       = "my-step-function"
  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using Pass states",
  "StartAt": "Hello",
  "States": {
    "Hello": {
      "Type": "Pass",
      "Result": "Hello",
      "Next": "World"
    },
    "World": {
      "Type": "Pass",
      "Result": "World",
      "End": true
    }
  }
}
EOF

  service_integrations = {
    dynamodb = {
      dynamodb = ["arn:aws:dynamodb:eu-west-1:052212379155:table/Test"]
    }

    lambda = {
      lambda = ["arn:aws:lambda:eu-west-1:123456789012:function:test1", "arn:aws:lambda:eu-west-1:123456789012:function:test2"]
    }
  }

  type = "STANDARD"

  tags = {
    Module = "my"
  }
}