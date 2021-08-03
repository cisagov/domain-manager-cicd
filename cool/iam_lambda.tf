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

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.ecs_task.arn
}