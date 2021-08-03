# ===================================
# Lambda Permission
# ===================================
resource "aws_lambda_permission" "ses_receive_emails" {
  statement_id   = "GiveSESPermissiontoInvokeFunction"
  principal      = "ses.amazonaws.com"
  action         = "lambda:InvokeFunction"
  source_account = var.account_id
  function_name  = aws_lambda_function.receive_emails.function_name
}

# ===================================
# SES Receipt Rule
# ===================================
resource "aws_ses_receipt_rule" "domains" {
  name          = "${var.app}-${var.env}-store"
  rule_set_name = "domains-rule-set"
  recipients    = []
  enabled       = true
  scan_enabled  = true

  lambda_action {
    function_arn = aws_lambda_function.receive_emails.arn
    position     = 1
  }
}
