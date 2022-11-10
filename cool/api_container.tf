locals {
  api_name               = "${var.app}-${var.env}-api"
  api_container_name     = "api"
  api_container_port     = 5000
  api_container_protocol = "HTTP"
  api_load_balancer_port = 443

  api_environment = {
    "FLASK_APP" : "main"
    "FLASK_DEBUG" : 0
    "APP_NAME" : var.app
    "APP_ENV" : var.env
    "DB_PW" : aws_ssm_parameter.docdb_password.value
    "DB_USER" : aws_ssm_parameter.docdb_username.value
    "DB_HOST" : module.docdb.endpoint
    "DB_PORT" : 27017
    "MONGO_TYPE" : "DOCUMENTDB"
    "STATIC_GEN_URL" : "http://localhost:8000"
    "TEMPLATE_BUCKET" : aws_s3_bucket.templates.id
    "WEBSITE_BUCKET" : aws_s3_bucket.websites.id
    "WORKERS" : 6
    "API_KEY" : aws_ssm_parameter.api_key.value
    "AWS_COGNITO_ENABLED" : 1
    "AWS_COGNITO_USER_POOL_ID" : aws_cognito_user_pool.pool.id
    "AWS_COGNITO_USER_POOL_CLIENT_ID" : aws_cognito_user_pool_client.client.id
    "AWS_COGNITO_ADMIN_GROUP_NAME" : aws_cognito_user_group.admin.name
    "TWO_CAPTCHA" : aws_ssm_parameter.two_captcha.value
    "SES_ASSUME_ROLE_ARN" : var.ses_arn
    "SMTP_FROM" : var.ses_from
    "NEW_USER_NOTIFICATION_EMAIL_ADDRESS" : var.new_user_notification_email_address
    "DEPLOYED_DATE" : var.deployed_date
    "API_COMMIT_ID" : var.api_image_tag
    "UI_COMMIT_ID" : var.ui_image_tag
  }
}


# ===========================
# APP CREDENTIALS
# ===========================
resource "random_password" "api_key" {
  length  = 32
  number  = false
  special = false
  upper   = true
}

resource "aws_ssm_parameter" "api_key" {
  name        = "/${var.app}/${var.env}/api/key"
  description = "api key for ${var.app}"
  type        = "SecureString"
  value       = random_password.api_key.result
  tags        = local.tags
}

# ===========================
# CLOUDWATCH LOGS
# ===========================
resource "aws_cloudwatch_log_group" "api" {
  name              = local.api_name
  retention_in_days = var.log_retention_days
  tags              = local.tags
}

# ===========================
# CONTAINER DEFINITION
# ===========================
module "api_container" {
  source          = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.47.0"
  container_name  = local.api_container_name
  container_image = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.api_image_repo}:${var.api_image_tag}"
  essential       = "true"
  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-region        = var.region
      awslogs-group         = aws_cloudwatch_log_group.api.name
      awslogs-stream-prefix = "/ecs/${local.api_container_name}"
    }
  }
  port_mappings = [
    {
      containerPort = local.api_container_port
      hostPort      = local.api_container_port
      protocol      = "tcp"
    }
  ]

  environment = concat([
    for key in keys(local.api_environment) :
    {
      name  = key
      value = local.api_environment[key]
    }
    ],
    [
      {
        name  = "AWS_REGION"
        value = var.region
      },
      {
        name  = "AWS_DEFAULT_REGION"
        value = var.region
      }
  ])
}
