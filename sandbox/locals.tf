# ===========================
# LOCALS
# ===========================
locals {
  allowed_actions = [
    "acm:*",
    "s3:*",
    "route53:*",
    "cloudfront:*",
    "cognito-identity:*",
    "cognito-idp:*",
    "sts:AssumeRole",
    "ses:*",
  ]
  # API LOCALS
  api_name               = "${var.app}-${var.env}-api"
  api_container_name     = "${var.app}-api"
  api_container_port     = 5000
  api_container_protocol = "HTTP"
  api_load_balancer_port = 443

  api_environment = {
    "FLASK_APP" : "main"
    "FLASK_DEBUG" : 0
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
    "TWO_CAPTCHA" : data.aws_ssm_parameter.two_captcha.value
    "SES_ASSUME_ROLE_ARN" : var.ses_arn
    "SMTP_FROM" : "domainmanager@cyber.dhs.gov"
    "NEW_USER_NOTIFICATION_EMAIL_ADDRESS" : var.new_user_notification_email_address
    "DEPLOYED_DATE" : var.deployed_date
    "API_COMMIT_ID" : var.api_image_tag
    "UI_COMMIT_ID" : var.ui_image_tag
  }

  # UI LOCALS
  ui_container_port     = 80
  ui_container_name     = "ui"
  ui_container_protocol = "HTTP"
  ui_load_balancer_port = 443
  ui_name               = "${var.app}-${var.env}-ui"

  ui_environment = {
    "API_URL" : "https://${aws_route53_record.domain.name}"
    "DEPLOYED_DATE" : var.deployed_date
    "UI_COMMIT_ID" : var.ui_image_tag
  }
}
