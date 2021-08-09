# ===================================
# SES Receipt Rule
# ===================================
resource "aws_ses_receipt_rule_set" "primary_rule_set" {
  rule_set_name = "${var.app}-${var.env}-primary"

}

resource "aws_ses_receipt_rule" "domains" {
  name          = "${var.app}-${var.env}-store"
  rule_set_name = aws_ses_receipt_rule_set.primary_rule_set.rule_set_name
  recipients    = []
  enabled       = true
  scan_enabled  = true

  sns_action {
    topic_arn = aws_sns_topic.emails.arn
    position  = 1
  }
}

resource "aws_ses_active_receipt_rule_set" "main" {
  rule_set_name = aws_ses_receipt_rule_set.primary_rule_set.rule_set_name
}
