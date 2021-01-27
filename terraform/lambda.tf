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
# Lambda Functions
# ===================================
locals {
  functions = [
    "categorize",
    "check_category",
    "check_category_queue"
  ]
}

resource "aws_lambda_function" "function" {
  count            = length(local.functions)
  function_name    = "${var.app}-${var.env}-${element(local.functions, count.index)}"
  filename         = data.archive_file.code.output_path
  handler          = "lambda_functions.${element(local.functions, count.index)}.handler"
  layers           = [aws_lambda_layer_version.layer.arn]
  role             = aws_iam_role.lambda_exec_role.arn
  memory_size      = 4096
  runtime          = "python3.8"
  source_code_hash = data.archive_file.code.output_base64sha256
  timeout          = 900

  environment {
    variables = local.lambda_environment
  }

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.api.id]
  }
}

# ===================================
# Queue Check Category Cloudwatch
# ===================================
resource "aws_cloudwatch_event_rule" "check_category_queue" {
  name                = "${var.app}-${var.env}-check_category_queue"
  description         = "Schedule to queue check category"
  schedule_expression = "rate(8 hours)"
}

resource "aws_cloudwatch_event_target" "check_category_queue" {
  rule      = aws_cloudwatch_event_rule.check_category_queue.name
  target_id = "lambda"
  arn       = aws_lambda_function.function[index(local.functions, "check_category_queue")].arn
}

resource "aws_lambda_permission" "check_category_queue" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function[index(local.functions, "check_category_queue")].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_lambda_function.function[index(local.functions, "check_category_queue")].arn
}
