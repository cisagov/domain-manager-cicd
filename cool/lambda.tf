locals {
  lambda_environment = {
    "BROWSERLESS_ENDPOINT" : "${aws_lb.network.dns_name}:${local.browserless_port}"
    "DB_HOST" : module.documentdb.endpoint
    "DB_PORT" : 27017
    "DB_PW" : aws_ssm_parameter.docdb_password.value
    "DB_USER" : aws_ssm_parameter.docdb_username.value
    "MONGO_TYPE" : "DOCUMENTDB"
    "TEMPLATE_BUCKET" : aws_s3_bucket.templates.id
    "WEBSITE_BUCKET" : aws_s3_bucket.websites.id
    "TWO_CAPTCHA" : aws_ssm_parameter.two_captcha.value
    "SQS_CHECK_CATEGORY_URL" : aws_sqs_queue.check_category.id
    "SQS_CATEGORIZE_URL" : aws_sqs_queue.categorize.id
  }

  functions = [
    "categorize",
    "check_category",
    "check_category_queue"
  ]

}

# ===================================
# Requirements
# ===================================
data "archive_file" "layer" {
  type        = "zip"
  source_dir  = "${path.module}/layer"
  output_path = "${path.module}/output/layer.zip"
}

resource "aws_lambda_layer_version" "layer" {
  filename         = data.archive_file.layer.output_path
  source_code_hash = data.archive_file.layer.output_path
  layer_name       = "${var.app}-${var.env}-layer"

  compatible_runtimes = ["python3.8"]

  lifecycle {
    create_before_destroy = true
  }
}

# ===================================
# Source Code
# ===================================
data "archive_file" "code" {
  type       = "zip"
  source_dir = "${path.module}/layer/python/"
  # source_dir  = "${path.module}/../../domain-manager-api/src/"
  output_path = "${path.module}/output/code.zip"
}

# ===================================
# Lambda Functions
# ===================================
resource "aws_lambda_function" "function" {
  count            = length(local.functions)
  function_name    = "${var.app}-${var.env}-${element(local.functions, count.index)}"
  filename         = data.archive_file.code.output_path
  handler          = "lambda_functions.${element(local.functions, count.index)}.handler"
  layers           = [aws_lambda_layer_version.layer.arn]
  role             = local.lambda_execution_role
  memory_size      = 4096
  runtime          = "python3.8"
  source_code_hash = data.archive_file.code.output_base64sha256
  timeout          = 900
  tags             = local.tags

  environment {
    variables = local.lambda_environment
  }

  vpc_config {
    subnet_ids         = local.private_subnet_ids
    security_group_ids = [aws_security_group.api.id]
  }
}

# # ===================================
# # Queue Check Category Cloudwatch
# # ===================================
# resource "aws_cloudwatch_event_rule" "check_category_queue" {
#   name                = "${var.app}-${var.env}-check_category_queue"
#   description         = "Schedule to queue check category"
#   schedule_expression = "rate(8 hours)"
#   tags                = local.tags
# }

# resource "aws_cloudwatch_event_target" "check_category_queue" {
#   rule      = aws_cloudwatch_event_rule.check_category_queue.name
#   target_id = "lambda"
#   arn       = aws_lambda_function.function[index(local.functions, "check_category_queue")].arn
# }

# resource "aws_lambda_permission" "check_category_queue" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.function[index(local.functions, "check_category_queue")].function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_lambda_function.function[index(local.functions, "check_category_queue")].arn
# }
