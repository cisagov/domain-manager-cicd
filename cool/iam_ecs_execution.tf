# ------------------------------------------------------------------------------
# Create the IAM role that allows sufficient AWS permissions to execute
# Domain Manager ECS in the Domain Manager account.
# ------------------------------------------------------------------------------

resource "aws_iam_role" "ecs_execution" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_ecs.json
  description        = "ECS Execution Role for starting containers"
  name               = "${var.app}-${var.env}-ecs_execution"
}

# ------------------------------------------------------------------------------
# Create the IAM policy that allows sufficient AWS permissions to execute
# Domain Manager ECS in the Domain Manager account.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "ecs_execution" {
  statement {
    actions = [
      "ssm:GetParameters",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_execution" {
  description = "ECS Execution policy for starting containers"
  name        = "${var.app}-${var.env}-ecs_execution"
  policy      = data.aws_iam_policy_document.ecs_execution.json
}

# ------------------------------------------------------------------------------
# Attach the policies that allow sufficient AWS permissions to execute Domain
# Manager ECS in the Domain Manager account to the appropriate role.
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  policy_arn = aws_iam_policy.ecs_execution.arn
  role       = aws_iam_role.ecs_execution.name
}

resource "aws_iam_role_policy_attachment" "ecs_execution_managed" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_execution.name
}
