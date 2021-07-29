# ===================================
# SES Receipt Rule
# ===================================
resource "aws_ses_receipt_rule" "domains" {
  name          = "store"
  rule_set_name = "domains-rule-set"
  recipients    = []
  enabled       = true
  scan_enabled  = true

  lambda_action {
    function_arn = ""
    position     = 1
  }
}