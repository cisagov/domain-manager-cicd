resource "aws_sns_topic" "emails" {
  name = "${var.app}-${var.env}-emails"
}

resource "aws_lambda_permission" "sns_lambda_emails" {
  statement_id   = "GiveSNSPermissiontoInvokeFunction"
  principal      = "sns.amazonaws.com"
  action         = "lambda:InvokeFunction"
  source_account = var.account_id
  function_name  = aws_lambda_function.receive_emails.function_name
}

resource "aws_sns_topic_subscription" "lambda_emails" {
  protocol  = "lambda"
  topic_arn = aws_sns_topic.emails.arn
  endpoint  = aws_lambda_function.receive_emails.arn
}
