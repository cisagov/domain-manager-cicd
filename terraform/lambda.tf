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
  type        = "zip"
  source_dir  = "${path.module}/../../domain-manager-api/src/"
  output_path = "${path.module}/output/code.zip"
}

# ===================================
# Sync DB Lambda Function
# ===================================
resource "aws_lambda_function" "sync_db" {
  filename         = data.archive_file.code.output_path
  function_name    = "${var.app}-${var.env}-sync_db"
  handler          = "lambda_functions.sync_db.handler.lambda_handler"
  layers           = [aws_lambda_layer_version.layer.arn]
  role             = aws_iam_role.lambda_exec_role.arn
  memory_size      = var.sync_db_memory
  runtime          = "python3.8"
  source_code_hash = data.archive_file.code.output_base64sha256
  timeout          = var.sync_db_timeout

  environment {
    variables = local.lambda_environment
  }

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.api.id]
  }
}

# ===================================
# Sync DB CloudWatch Event
# ===================================
# resource "aws_cloudwatch_event_rule" "syncdb" {
#   name                = "${var.app}-${var.env}-sync_db"
#   description         = "Schedule to run Sync DB Lambda Function"
#   schedule_expression = var.sync_db_schedule
# }
# resource "aws_cloudwatch_event_target" "syncdb" {
#   rule      = aws_cloudwatch_event_rule.syncdb.name
#   target_id = "lambda"
#   arn       = aws_lambda_function.sync_db.arn
# }
# resource "aws_lambda_permission" "sync_db" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.sync_db.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.syncdb.arn
# }
