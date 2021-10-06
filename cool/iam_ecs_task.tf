
# ------------------------------------------------------------------------------
# Create the IAM role that allows sufficient AWS permissions to execute
# Domain Manager ECS tasks in the Domain Manager account.
# ------------------------------------------------------------------------------

resource "aws_iam_role" "ecs_task" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_ecs.json
  description        = "ECS Task Role for accessing resources"
  name               = "${var.app}-${var.env}-ecs_task"
}

# ------------------------------------------------------------------------------
# Create the IAM policy that allows sufficient AWS permissions to execute
# Domain Manager ECS tasks in the Domain Manager account.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "ecs_task" {
  # ACM
  statement {
    actions = [
      "acm:DeleteCertificate",
      "acm:GetCertificate",
      "acm:ListTagsForCertificate",
      "acm:RemoveTagsFromCertificate",
      "acm:UpdateCertificateOptions",
      "acm:AddTagsToCertificate",
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:RequestCertificate",
    ]

    resources = ["*"]
  }

  # Cloudfront
  statement {
    actions = [
      "cloudfront:DeleteDistribution",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:UntagResource",
      "cloudfront:UpdateDistribution",
      "cloudfront:CreateDistribution",
      "cloudfront:CreateDistributionWithTags",
      "cloudfront:ListDistributions",
      "cloudfront:ListStreamingDistributions",
      "cloudfront:ListTagsForResource",
      "cloudfront:TagResource",
    ]

    resources = ["*"]
  }

  # Cognito
  statement {
    actions = [
      "cognito-idp:AdminAddUserToGroup",
      "cognito-idp:AdminConfirmSignUp",
      "cognito-idp:AdminCreateUser",
      "cognito-idp:AdminDeleteUser",
      "cognito-idp:AdminDisableUser",
      "cognito-idp:AdminEnableUser",
      "cognito-idp:AdminGetUser",
      "cognito-idp:AdminInitiateAuth",
      "cognito-idp:AdminListDevices",
      "cognito-idp:AdminListGroupsForUser",
      "cognito-idp:AdminUpdateUserAttributes",
      "cognito-idp:AdminRemoveUserFromGroup",
      "cognito-idp:AdminResetUserPassword",
      "cognito-idp:ListUsers",
      "cognito-idp:ListUsersInGroup",
      "cognito-idp:SignUp",
    ]

    resources = ["*"]
  }

  # Route53
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ChangeTagsForResource",
      "route53:CreateHostedZone",
      "route53:DeleteHostedZone",
      "route53:GetHostedZone",
      "route53:GetHostedZoneCount",
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource"
    ]

    resources = ["*"]
  }

  # S3
  statement {
    actions = [
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:DeleteBucketPolicy",
      "s3:DeleteBucketWebsite",
      "s3:DeleteObject",
      "s3:GetBucketWebsite",
      "s3:GetObject",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:PutBucketPolicy",
      "s3:PutBucketPublicAccessBlock",
      "s3:PutBucketTagging",
      "s3:PutBucketWebsite",
      "s3:PutObject"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ses:*"
    ]

    resources = ["*"]
  }

  # STS
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_task" {
  description = "ECS Task Policy for accessing resources"
  name        = "${var.app}-${var.env}-ecs_task"
  policy      = data.aws_iam_policy_document.ecs_task.json
}

# ------------------------------------------------------------------------------
# Attach the policy that allows sufficient AWS permissions to execute Domain
# Manager ECS tasks in the Domain Manager account to the appropriate role.
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "ecs_task" {
  policy_arn = aws_iam_policy.ecs_task.arn
  role       = aws_iam_role.ecs_task.name
}
