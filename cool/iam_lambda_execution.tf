locals {
  provisiondomainmanager_policy_description = "Domain Manager Provision Account"
  provisiondomainmanager_policy_name        = "${var.app}-${var.env}"
}

# ===================================
# Lambda
# ===================================
data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

# ------------------------------------------------------------------------------
# Create the IAM role that allows sufficient AWS permissions to execute
# Domain Manager Lambdas in the Domain Manager account.
# ------------------------------------------------------------------------------

resource "aws_iam_role" "lambda" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
  description        = "Lambda access to resources"
  name               = "${var.app}-${var.env}-lambda"
}

# ------------------------------------------------------------------------------
# Create the IAM policy that allows sufficient AWS permissions to execute
# Domain Manager Lambdas in the Domain Manager account.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "lambda" {
  # EC2
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
    ]

    resources = ["*"]
  }

  # Logs
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  # SQS
  statement {
    actions = [
      "sqs:SendMessage",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda" {
  description = "Permissions needed to run Lambda."
  name        = "${var.app}-${var.env}-lambda"
  policy      = data.aws_iam_policy_document.lambda.json
}

# ------------------------------------------------------------------------------
# Attach the policy that allows sufficient AWS permissions to execute Domain
# Manager Lambdas in the Domain Manager account to the appropriate role.
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "lambda" {
  policy_arn = aws_iam_policy.lambda.arn
  role       = aws_iam_role.lambda.name
}
