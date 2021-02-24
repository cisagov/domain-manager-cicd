# ------------------------------------------------------------------------------
# Create the IAM policy that allows all of the permissions necessary
# to provision the resources required in the assessment account.
#
# Multiple policies are needed as there is a character limit to policies.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ACM, COGNITO, EC2
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "policy1" {
  statement {
    actions = [
      "acm:DeleteCertificate",
      "acm:GetCertificate",
      "acm:ListTagsForCertificate",
      "acm:RemoveTagsFromCertificate",
      "acm:UpdateCertificateOptions",
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
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteTags",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/environment"
      values   = [var.env]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = [var.app]
    }
  }

  statement {
    actions = [
      "acm:AddTagsToCertificate",
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:RequestCertificate",
      "cognito-idp:CreateUserPool",
      "cognito-idp:DescribeUserPool",
      "cognito-idp:DescribeUserPoolClient",
      "cognito-idp:DescribeUserPoolDomain",
      "cognito-idp:ListUserPools",
      "cognito-idp:TagResource",
      "ec2:CreateNetworkInterface",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy1" {
  description = "Provision Resources - ACM, Cognito, EC2"
  name        = "${var.app}-${var.env}-provision-acm-cognito-ec2"
  policy      = data.aws_iam_policy_document.policy1.json
}

resource "aws_iam_role_policy_attachment" "policy1" {
  policy_arn = aws_iam_policy.policy1.arn
  role       = aws_iam_role.provision_role.name
}

# ------------------------------------------------------------------------------
# ECS, ELB, EVENTS
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "ecr" {
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
      "ecr:UploadLayerPart"
    ]


    resources = ["arn:aws:ecr:*:*:repository/domain-manager-*"]
  }

  statement {
    actions = [
      "ecr:DescribeRegistry",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:ListTagsForResource",
      "ecr:TagResource",
      "ecr:UntagResource"
    ]

    resources = ["*"]
  }
}


data "aws_iam_policy_document" "policy2" {

  statement {
    actions = [
      "ecs:CreateService",
      "ecs:DeleteCluster",
      "ecs:DeleteService",
      "ecs:DeregisterContainerInstance",
      "ecs:ListContainerInstances",
      "ecs:ListServices",
      "ecs:ListTaskDefinitionFamilies",
      "ecs:ListTaskDefinitions",
      "ecs:ListTasks",
      "ecs:RegisterContainerInstance",
      "ecs:RunTask",
      "ecs:StartTask",
      "ecs:StopTask",
      "ecs:SubmitContainerStateChange",
      "ecs:UpdateContainerAgent",
      "ecs:UpdateContainerInstancesState",
      "ecs:UpdateService",
      "ecs:UpdateServicePrimaryTaskSet",
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
      "events:UntagResource"
    ]

    resources = [
      "arn:aws:ecs:${local.region}:${local.account_id}:cluster/${var.app}-${var.env}*",
      "arn:aws:ecs:${local.region}:${local.account_id}:service/${var.app}-${var.env}*",
      "arn:aws:ecs:${local.region}:${local.account_id}:task/${var.app}-${var.env}*",
      "arn:aws:ecs:${local.region}:${local.account_id}:task-definition/${var.app}-${var.env}*",
      "arn:aws:elasticloadbalancing:${local.region}:${local.account_id}:listener/*/*${var.app}-${var.env}*",
      "arn:aws:elasticloadbalancing:${local.region}:${local.account_id}:listener-rule/*/*${var.app}-${var.env}*",
      "arn:aws:elasticloadbalancing:${local.region}:${local.account_id}:loadbalancer/*/*${var.app}-${var.env}*",
      "arn:aws:elasticloadbalancing:${local.region}:${local.account_id}:targetgroup/*${var.app}-${var.env}*",
      "arn:aws:events:${local.region}:${local.account_id}:rule/${var.app}-${var.env}*",
    ]
  }

  statement {
    actions = [
      "ecs:CreateCluster",
      "ecs:DeregisterTaskDefinition",
      "ecs:DescribeClusters",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListClusters",
      "ecs:RegisterTaskDefinition",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy2" {
  description = "Provision Resources - ECS, ELB, Events"
  name        = "${var.app}-${var.env}-provision-ecs-elb-events"
  policy      = data.aws_iam_policy_document.policy2.json
}

resource "aws_iam_role_policy_attachment" "policy2" {
  policy_arn = aws_iam_policy.policy2.arn
  role       = aws_iam_role.provision_role.name
}

# ------------------------------------------------------------------------------
# LAMBDA, LOGS, RDS
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "policy3" {

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
      "rds:StopDBInstance"
    ]

    resources = [
      "arn:aws:lambda:${local.region}:${local.account_id}:layer:${var.app}-${var.env}*",
      "arn:aws:lambda:${local.region}:${local.account_id}:function:${var.app}-${var.env}*",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:*${var.app}-${var.env}*:*",
      "arn:aws:rds:${local.region}:${local.account_id}:cluster:${var.app}-${var.env}*",
      "arn:aws:rds:${local.region}:${local.account_id}:cluster-pg:${var.app}-${var.env}*",
      "arn:aws:rds:${local.region}:${local.account_id}:cluster-snapshot:${var.app}-${var.env}*",
      "arn:aws:rds:${local.region}:${local.account_id}:db:${var.app}-${var.env}*",
      "arn:aws:rds:${local.region}:${local.account_id}:secgrp:${var.app}-${var.env}*",
      "arn:aws:rds:${local.region}:${local.account_id}:subgrp:${var.app}-${var.env}*",
    ]
  }

  statement {
    actions = [
      "lambda:CreateEventSourceMapping",
      "lambda:DeleteEventSourceMapping",
      "lambda:GetEventSourceMapping",
      "lambda:ListEventSourceMappings",
      "lambda:ListFunctions",
      "lambda:ListLayers",
      "lambda:UpdateEventSourceMapping",
      "logs:DescribeLogGroups"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy3" {
  description = "Provision Resources - Lambda, Logs, RDS"
  name        = "${var.app}-${var.env}-provision-lambda-logs-rds"
  policy      = data.aws_iam_policy_document.policy3.json
}

resource "aws_iam_role_policy_attachment" "policy3" {
  policy_arn = aws_iam_policy.policy3.arn
  role       = aws_iam_role.provision_role.name
}

# ------------------------------------------------------------------------------
# ROUTE53, S3, SQS, SSM
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "policy4" {

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
      "ssm:RemoveTagsFromResource"
    ]

    resources = [
      "arn:aws:s3:::*${var.app}-${var.env}*",
      "arn:aws:sqs:${local.region}:${local.account_id}:*${var.app}-${var.env}*",
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/${var.app}/${var.env}/*",
    ]
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ChangeTagsForResource",
      "route53:CreateHostedZone",
      "route53:DeleteHostedZone",
      "route53:GetChange",
      "route53:GetHostedZone",
      "route53:GetHostedZoneCount",
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
      "route53:ListTagsForResources",
      "ssm:DescribeParameters",
      "sts:GetCallerIdentity",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy4" {
  description = "Provision Resources - Route53, S3, SQS, SSM"
  name        = "${var.app}-${var.env}-provision-r53-s3-sqs-ssm"
  policy      = data.aws_iam_policy_document.policy4.json
}

resource "aws_iam_role_policy_attachment" "policy4" {
  policy_arn = aws_iam_policy.policy4.arn
  role       = aws_iam_role.provision_role.name
}

# ------------------------------------------------------------------------------
# ProvisionAccount Role
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "assume_role_doc" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::780016325729:root",
      ]
    }
  }
}

resource "aws_iam_role" "provision_role" {
  name               = "${var.app}-${var.env}-provision"
  assume_role_policy = data.aws_iam_policy_document.assume_role_doc.json
  description        = "test provision role for domain manager"
}

resource "aws_iam_role_policy_attachment" "iam_full_access" {
  role       = aws_iam_role.provision_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}
