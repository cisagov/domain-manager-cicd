# Categorize Queue
# resource "aws_sqs_queue" "categorize" {
#   name                       = "${var.app}-${var.env}-categorize"
#   visibility_timeout_seconds = 900
#   tags                       = local.tags
# }

# resource "aws_lambda_event_source_mapping" "categorize" {
#   event_source_arn = aws_sqs_queue.categorize.arn
#   enabled          = true
#   function_name    = aws_lambda_function.function[index(local.functions, "categorize")].function_name
#   batch_size       = 1
# }

# Check Category Queue
# resource "aws_sqs_queue" "check_category" {
#   name                       = "${var.app}-${var.env}-check_category"
#   visibility_timeout_seconds = 900
#   tags                       = local.tags
# }

# resource "aws_lambda_event_source_mapping" "check_category" {
#   event_source_arn = aws_sqs_queue.check_category.arn
#   enabled          = true
#   function_name    = aws_lambda_function.function[index(local.functions, "check_category")].function_name
#   batch_size       = 1
# }
