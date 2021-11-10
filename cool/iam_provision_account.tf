

# ------------------------------------------------------------------------------
# Create the IAM policies that allow sufficient permissions to provision
# all AWS resources for Domain Manager in the Domain Manager account.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "provision_acm_cloudwatch_cognito_ec2_doc" {
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

  # Cloudwatch
  statement {
    actions = [
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
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
      "cognito-idp:AdminListDevices",
      "cognito-idp:AdminListGroupsForUser",
      "cognito-idp:AdminRemoveUserFromGroup",
      "cognito-idp:AdminResetUserPassword",
      "cognito-idp:ConfirmSignUp",
      "cognito-idp:CreateGroup",
      "cognito-idp:CreateUserPoolClient",
      "cognito-idp:CreateUserPoolDomain",
      "cognito-idp:DeleteGroup",
      "cognito-idp:DeleteUser",
      "cognito-idp:DeleteUserPool",
      "cognito-idp:DeleteUserPoolClient",
      "cognito-idp:DeleteUserPoolDomain",
      "cognito-idp:GetGroup",
      "cognito-idp:GetUser",
      "cognito-idp:GetUserPoolMfaConfig",
      "cognito-idp:ListGroups",
      "cognito-idp:ListUserPoolClients",
      "cognito-idp:ListUsers",
      "cognito-idp:ListUsersInGroup",
      "cognito-idp:SetUserPoolMfaConfig",
      "cognito-idp:SignUp",
      "cognito-idp:UpdateGroup",
      "cognito-idp:UpdateUserPool",
      "cognito-idp:UpdateUserPoolClient",
      "cognito-idp:UpdateUserPoolDomain",
      "cognito-idp:CreateUserPool",
      "cognito-idp:DescribeUserPool",
      "cognito-idp:DescribeUserPoolClient",
      "cognito-idp:DescribeUserPoolDomain",
      "cognito-idp:ListUserPools",
      "cognito-idp:TagResource",
    ]

    resources = ["*"]
  }

  # EC2
  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteTags",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
      "ec2:AssignPrivateIpAddresses",
      "ec2:CreateNetworkInterface",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeVpcs",
      "ec2:UnassignPrivateIpAddresses",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "provision_acm_cloudwatch_cognito_ec2" {
  description = "ProvisionAccount (ACM, CloudWatch, Cognito, EC2)"
  name        = "${var.app}-${var.env}-acm-cloudwatch-cognito-ec2"
  policy      = data.aws_iam_policy_document.provision_acm_cloudwatch_cognito_ec2_doc.json
}

data "aws_iam_policy_document" "provision_ecr_ecs_elb_events_doc" {
  # ECR
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchDeleteImage",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:CreateRepository",
      "ecr:DeleteLifecyclePolicy",
      "ecr:DeleteRepository",
      "ecr:DeleteRepositoryPolicy",
      "ecr:DescribeImages",
      "ecr:GetLifecyclePolicy",
      "ecr:GetRepositoryPolicy",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:PutLifecyclePolicy",
      "ecr:SetRepositoryPolicy",
      "ecr:UploadLayerPart",
      "ecr:DescribeRegistry",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:ListTagsForResource",
      "ecr:TagResource",
      "ecr:UntagResource",
    ]

    resources = ["*"]
  }

  # ECS
  statement {
    actions = [
      "ecs:CreateService",
      "ecs:DeleteCluster",
      "ecs:DeleteService",
      "ecs:DeregisterContainerInstance",
      "ecs:RegisterContainerInstance",
      "ecs:RunTask",
      "ecs:StartTask",
      "ecs:StopTask",
      "ecs:SubmitContainerStateChange",
      "ecs:UpdateContainerAgent",
      "ecs:UpdateContainerInstancesState",
      "ecs:UpdateService",
      "ecs:UpdateServicePrimaryTaskSet",
      "ecs:CreateCluster",
      "ecs:DeregisterTaskDefinition",
      "ecs:DescribeClusters",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListClusters",
      "ecs:ListContainerInstances",
      "ecs:ListServices",
      "ecs:ListTaskDefinitionFamilies",
      "ecs:ListTaskDefinitions",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
    ]

    resources = ["*"]
  }

  # ELB
  statement {
    actions = [
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetRulePriorities",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebAcl",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
    ]

    resources = ["*"]
  }

  # Events
  statement {
    actions = [
      "events:DeleteRule",
      "events:DescribeRule",
      "events:DisableRule",
      "events:EnableRule",
      "events:ListRuleNamesByTarget",
      "events:ListRules",
      "events:ListTagsForResource",
      "events:ListTargetsByRule",
      "events:PutEvents",
      "events:PutPermission",
      "events:PutRule",
      "events:PutTargets",
      "events:RemovePermission",
      "events:RemoveTargets",
      "events:TagResource",
      "events:UntagResource",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "provision_ecr_ecs_elb_events" {
  description = "ProvisionAccount (ECR, ECS, ELB, Events)"
  name        = "${var.app}-${var.env}-ecr-ecs-elb-events"
  policy      = data.aws_iam_policy_document.provision_ecr_ecs_elb_events_doc.json
}

data "aws_iam_policy_document" "provision_lambda_logs_rds_doc" {
  # Lambda
  statement {
    actions = [
      "lambda:AddLayerVersionPermission",
      "lambda:AddPermission",
      "lambda:CreateCodeSigningConfig",
      "lambda:CreateFunction",
      "lambda:DeleteCodeSigningConfig",
      "lambda:DeleteFunction",
      "lambda:DeleteFunctionCodeSigningConfig",
      "lambda:DeleteFunctionConcurrency",
      "lambda:DeleteFunctionEventInvokeConfig",
      "lambda:DeleteLayerVersion",
      "lambda:DeleteProvisionedConcurrencyConfig",
      "lambda:GetCodeSigningConfig",
      "lambda:GetFunction",
      "lambda:GetFunctionCodeSigningConfig",
      "lambda:GetFunctionConcurrency",
      "lambda:GetFunctionConfiguration",
      "lambda:GetFunctionEventInvokeConfig",
      "lambda:GetLayerVersion",
      "lambda:GetLayerVersionPolicy",
      "lambda:GetLayerVersionPolicy",
      "lambda:GetPolicy",
      "lambda:GetProvisionedConcurrencyConfig",
      "lambda:InvokeFunction",
      "lambda:ListCodeSigningConfigs",
      "lambda:ListFunctionEventInvokeConfigs",
      "lambda:ListFunctionsByCodeSigningConfig",
      "lambda:ListLayerVersions",
      "lambda:ListProvisionedConcurrencyConfigs",
      "lambda:ListVersionsByFunction",
      "lambda:PublishLayerVersion",
      "lambda:PutFunctionCodeSigningConfig",
      "lambda:PutFunctionConcurrency",
      "lambda:PutFunctionEventInvokeConfig",
      "lambda:PutProvisionedConcurrencyConfig",
      "lambda:RemoveLayerVersionPermission",
      "lambda:RemovePermission",
      "lambda:UpdateCodeSigningConfig",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionCodeSigningConfig",
      "lambda:UpdateFunctionConfiguration",
      "lambda:UpdateFunctionEventInvokeConfig",
      "lambda:CreateEventSourceMapping",
      "lambda:DeleteEventSourceMapping",
      "lambda:GetEventSourceMapping",
      "lambda:ListEventSourceMappings",
      "lambda:ListFunctions",
      "lambda:ListLayers",
      "lambda:UpdateEventSourceMapping",
    ]

    resources = ["*"]
  }

  # Logs
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DeleteLogGroup",
      "logs:DeleteLogStream",
      "logs:DeleteMetricFilter",
      "logs:DeleteResourcePolicy",
      "logs:DeleteRetentionPolicy",
      "logs:DescribeLogStreams",
      "logs:DescribeMetricFilters",
      "logs:DescribeResourcePolicies",
      "logs:FilterLogEvents",
      "logs:GetLogEvents",
      "logs:GetLogGroupFields",
      "logs:GetLogRecord",
      "logs:ListTagsLogGroup",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutResourcePolicy",
      "logs:PutRetentionPolicy",
      "logs:TagLogGroup",
      "logs:UntagLogGroup",
      "logs:DescribeLogGroups",
    ]

    resources = ["*"]
  }

  # RDS
  statement {
    actions = [
      "rds:AddTagsToResource",
      "rds:AuthorizeDBSecurityGroupIngress",
      "rds:CopyDBClusterSnapshot",
      "rds:CopyDBParameterGroup",
      "rds:CopyDBSnapshot",
      "rds:CopyOptionGroup",
      "rds:CreateDBCluster",
      "rds:CreateDBClusterEndpoint",
      "rds:CreateDBClusterParameterGroup",
      "rds:CreateDBClusterSnapshot",
      "rds:CreateDBInstance",
      "rds:CreateDBParameterGroup",
      "rds:CreateDBSecurityGroup",
      "rds:CreateDBSnapshot",
      "rds:CreateDBSubnetGroup",
      "rds:CreateEventSubscription",
      "rds:CreateOptionGroup",
      "rds:DeleteDBCluster",
      "rds:DeleteDBClusterEndpoint",
      "rds:DeleteDBClusterParameterGroup",
      "rds:DeleteDBClusterSnapshot",
      "rds:DeleteDBInstance",
      "rds:DeleteDBInstanceAutomatedBackup",
      "rds:DeleteDBParameterGroup",
      "rds:DeleteDBSecurityGroup",
      "rds:DeleteDBSnapshot",
      "rds:DeleteDBSubnetGroup",
      "rds:DeleteEventSubscription",
      "rds:DeleteOptionGroup",
      "rds:DescribeDBClusterEndpoints",
      "rds:DescribeDBClusterParameterGroups",
      "rds:DescribeDBClusterParameters",
      "rds:DescribeDBClusterSnapshotAttributes",
      "rds:DescribeDBClusterSnapshots",
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstanceAutomatedBackups",
      "rds:DescribeDBInstances",
      "rds:DescribeDBParameterGroups",
      "rds:DescribeDBParameters",
      "rds:DescribeDBSecurityGroups",
      "rds:DescribeDBSnapshotAttributes",
      "rds:DescribeDBSnapshots",
      "rds:DescribeDBSubnetGroups",
      "rds:DescribeEngineDefaultClusterParameters",
      "rds:DescribeEngineDefaultParameters",
      "rds:DescribeEventCategories",
      "rds:DescribeEventSubscriptions",
      "rds:DescribeEvents",
      "rds:DescribeOptionGroupOptions",
      "rds:DescribeOptionGroups",
      "rds:ListTagsForResource",
      "rds:ModifyDBCluster",
      "rds:ModifyDBClusterEndpoint",
      "rds:ModifyDBClusterParameterGroup",
      "rds:ModifyDBClusterSnapshotAttribute",
      "rds:ModifyDBInstance",
      "rds:ModifyDBParameterGroup",
      "rds:ModifyDBSnapshot",
      "rds:ModifyDBSnapshotAttribute",
      "rds:ModifyDBSubnetGroup",
      "rds:ModifyEventSubscription",
      "rds:ModifyOptionGroup",
      "rds:RebootDBInstance",
      "rds:RemoveTagsFromResource",
      "rds:ResetDBClusterParameterGroup",
      "rds:ResetDBParameterGroup",
      "rds:RestoreDBClusterFromS3",
      "rds:RestoreDBClusterFromSnapshot",
      "rds:RestoreDBClusterToPointInTime",
      "rds:RestoreDBInstanceFromDBSnapshot",
      "rds:RestoreDBInstanceFromS3",
      "rds:RestoreDBInstanceToPointInTime",
      "rds:RevokeDBSecurityGroupIngress",
      "rds:StartDBCluster",
      "rds:StartDBInstance",
      "rds:StopDBCluster",
      "rds:StopDBInstance",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "provision_lambda_logs_rds" {
  description = "ProvisionAccount (Lambda, Logs, RDS)"
  name        = "${var.app}-${var.env}-lambda-logs-rds"
  policy      = data.aws_iam_policy_document.provision_lambda_logs_rds_doc.json
}

data "aws_iam_policy_document" "provision_s3_sqs_ssm_doc" {
  # S3
  statement {
    actions = [
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:DeleteBucketPolicy",
      "s3:DeleteBucketWebsite",
      "s3:DeleteObject",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "s3:GetBucketNotification",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketPolicy",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetBucketWebsite",
      "s3:GetEncryptionConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetReplicationConfiguration",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:PutAccelerateConfiguration",
      "s3:PutBucketAcl",
      "s3:PutBucketCORS",
      "s3:PutBucketLogging",
      "s3:PutBucketNotification",
      "s3:PutBucketObjectLockConfiguration",
      "s3:PutBucketPolicy",
      "s3:PutBucketPublicAccessBlock",
      "s3:PutBucketRequestPayment",
      "s3:PutBucketTagging",
      "s3:PutBucketVersioning",
      "s3:PutBucketWebsite",
      "s3:PutEncryptionConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutReplicationConfiguration",
      "s3:ReplicateObject",
      "s3:RestoreObject",
    ]

    resources = ["*"]
  }

  # SES
  statement {
    actions = [
      "ses:*"
    ]

    resources = ["*"]
  }

  # SQS
  statement {
    actions = [
      "sqs:AddPermission",
      "sqs:CreateQueue",
      "sqs:DeleteMessage",
      "sqs:DeleteQueue",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:ListQueueTags",
      "sqs:ListQueues",
      "sqs:PurgeQueue",
      "sqs:ReceiveMessage",
      "sqs:RemovePermission",
      "sqs:SetQueueAttributes",
      "sqs:TagQueue",
      "sqs:UntagQueue",
    ]

    resources = ["*"]
  }

  # SSM
  statement {
    actions = [
      "ssm:AddTagsToResource",
      "ssm:DeleteParameter",
      "ssm:DeleteParameters",
      "ssm:DescribeDocumentParameters",
      "ssm:GetParameter",
      "ssm:GetParameterHistory",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "ssm:LabelParameterVersion",
      "ssm:ListTagsForResource",
      "ssm:PutParameter",
      "ssm:RemoveTagsFromResource",
      "ssm:DescribeParameters",
    ]

    resources = ["*"]
  }

  # STS
  statement {
    actions = [
      "sts:GetCallerIdentity",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "provision_s3_sqs_ssm" {
  description = "ProvisionAccount (S3, SQS, SSM)"
  name        = "${var.app}-${var.env}-provision-s3-sqs-ssm"
  policy      = data.aws_iam_policy_document.provision_s3_sqs_ssm_doc.json
}


# ------------------------------------------------------------------------------
# Attach to the ProvisionAccount role the IAM policies that allow
# sufficient permissions to provision Domain Manager in the Domain Manager
# account.
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "provision_acm_cloudwatch_cognito_ec2" {
  policy_arn = aws_iam_policy.provision_acm_cloudwatch_cognito_ec2.arn
  role       = var.provision_account_role_name
}

resource "aws_iam_role_policy_attachment" "provision_ecr_ecs_elb_events" {
  policy_arn = aws_iam_policy.provision_ecr_ecs_elb_events.arn
  role       = var.provision_account_role_name
}

resource "aws_iam_role_policy_attachment" "provision_lambda_logs_rds" {
  policy_arn = aws_iam_policy.provision_lambda_logs_rds.arn
  role       = var.provision_account_role_name
}

resource "aws_iam_role_policy_attachment" "provision_s3_sqs_ssm" {
  policy_arn = aws_iam_policy.provision_s3_sqs_ssm.arn
  role       = var.provision_account_role_name
}

resource "aws_iam_role_policy_attachment" "provision_ecs_task" {
  policy_arn = aws_iam_policy.ecs_task.arn
  role       = var.provision_account_role_name
}
