# ===================================
# Lambda
# ===================================
resource "aws_iam_role" "lambda_exec_role" {
  name               = "${var.app}-${var.env}-lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    sid    = "AllowCreatingLogGroups"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:*"
    ]

    actions = [
      "logs:CreateLogGroup"
    ]
  }

  statement {
    sid    = "AllowWritingLogs"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*"
    ]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    sid    = "AllowVPC"
    effect = "Allow"

    resources = [
      "*"
    ]

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      var.ses_arn
    ]
  }
}

resource "aws_iam_policy" "lambda_iam_policy" {
  name   = "${var.app}-${var.env}-lambda"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_iam_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.ecs_task.arn
}
