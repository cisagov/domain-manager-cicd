# ===================================
# Lambda Layer
# ===================================
data "archive_file" "layer" {
  type        = "zip"
  source_dir  = "${path.module}/layer/"
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
# Lambda Function
# ===================================
data "archive_file" "code" {
  type        = "zip"
  source_dir  = "${path.module}/../../domain-manager-api/src/"
  output_path = "${path.module}/output/code.zip"
}

resource "aws_lambda_function" "receive_emails" {
  filename         = data.archive_file.code.output_path
  function_name    = "${var.app}-${var.env}-receive-emails"
  handler          = "lambda_functions.receive_emails.lambda_handler"
  role             = aws_iam_role.lambda_exec_role.arn
  memory_size      = var.lambda_memory
  runtime          = "python3.8"
  source_code_hash = data.archive_file.code.output_base64sha256
  timeout          = var.lambda_timeout

  layers = [aws_lambda_layer_version.layer.arn]

  environment {
    variables = local.api_environment
  }

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.api.id]
  }
}
