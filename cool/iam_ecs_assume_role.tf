# ------------------------------------------------------------------------------
# Create an IAM policy document that allows ECS to assume this role.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "assume_role_ecs" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}
