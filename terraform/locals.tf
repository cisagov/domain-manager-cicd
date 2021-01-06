# ===========================
# LOCALS
# ===========================
locals {
  # API LOCALS
  api_name               = "${var.app}-${var.env}-api"
  api_container_name     = "${var.app}-api"
  api_container_port     = 5000
  api_container_protocol = "HTTP"
  api_load_balancer_port = 8043

  api_environment = {
    "FLASK_APP" : "main"
    "FLASK_ENV" : "development"
    "DEBUG" : 1
    "DB_PW" : aws_ssm_parameter.docdb_password.value
    "DB_USER" : aws_ssm_parameter.docdb_username.value
    "DB_HOST" : module.documentdb.endpoint
    "DB_PORT" : 27017
    "MONGO_TYPE" : "DOCUMENTDB"
    "TEMPLATE_BUCKET" : aws_s3_bucket.bucket.id
    "BROWSERLESS_ENDPOINT" : "${aws_lb.network.dns_name}:${local.browserless_port}"
    "WORKERS" : 4
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
    "TEMPLATE_BUCKET" : aws_s3_bucket.bucket.id
    "DB_PW" : aws_ssm_parameter.docdb_password.value
    "DB_USER" : aws_ssm_parameter.docdb_username.value
  }

  # BROWSERLESS LOCALS
  browserless_port           = 3000
  browserless_name           = "${var.app}-${var.env}-browserless"
  browserless_container_name = "browserless"
}
