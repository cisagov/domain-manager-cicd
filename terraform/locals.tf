# ===========================
# LOCALS
# ===========================
locals {
  # API LOCALS
  api_name               = "${var.app}-${var.env}-api"
  api_container_name     = "${var.app}-api"
  api_container_port     = 5000
  api_container_protocol = "HTTP"
  api_load_balancer_port = 443

  api_environment = {
    "FLASK_APP" : "main"
    "FLASK_ENV" : "production"
    "DEBUG" : 0
    "DB_PW" : aws_ssm_parameter.docdb_password.value
    "DB_USER" : aws_ssm_parameter.docdb_username.value
    "DB_HOST" : module.documentdb.endpoint
    "DB_PORT" : 27017
    "MONGO_TYPE" : "DOCUMENTDB"
    "TEMPLATE_BUCKET" : aws_s3_bucket.templates.id
    "WEBSITE_BUCKET" : aws_s3_bucket.websites.id
    "BROWSERLESS_ENDPOINT" : "${aws_lb.network.dns_name}:${local.browserless_port}"
    "WORKERS" : 6
    "AWS_REGION" : var.region
    "AWS_DEFAULT_REGION" : var.region
    "API_KEY" : aws_ssm_parameter.api_key.value
    "AWS_COGNITO_ENABLED" : 1
    "AWS_COGNITO_USER_POOL_ID" : aws_cognito_user_pool.pool.id
    "AWS_COGNITO_USER_POOL_CLIENT_ID" : aws_cognito_user_pool_client.client.id
  }

  lambda_environment = {
    "DB_HOST" : module.documentdb.endpoint
    "DB_PORT" : 27017
    "MONGO_TYPE" : "DOCUMENTDB"
    "TEMPLATE_BUCKET" : aws_s3_bucket.templates.id
    "WEBSITE_BUCKET" : aws_s3_bucket.websites.id
    "DB_PW" : aws_ssm_parameter.docdb_password.value
    "DB_USER" : aws_ssm_parameter.docdb_username.value
  }

  # BROWSERLESS LOCALS
  browserless_port           = 3000
  browserless_name           = "${var.app}-${var.env}-browserless"
  browserless_container_name = "browserless"

  # UI LOCALS
  ui_container_port     = 80
  ui_container_name     = "ui"
  ui_container_protocol = "HTTP"
  ui_load_balancer_port = 443
  ui_name               = "${var.app}-${var.env}-ui"

  ui_environment = {
    "API_URL" : "https://${aws_route53_record.domain.name}"
    "AWS_PROJECT_REGION" : var.region
    "AWS_USER_POOLS_ID" : aws_cognito_user_pool.pool.id
    "OAUTH_DOMAIN" : "${aws_cognito_user_pool_domain.domain.domain}.auth.${var.region}.amazoncognito.com"
    "OAUTH_REDIRECT_URL" : "https://${aws_route53_record.domain.name}"
    "AWS_USER_POOLS_WEB_CLIENT_ID" : aws_cognito_user_pool_client.client.id
  }
}
