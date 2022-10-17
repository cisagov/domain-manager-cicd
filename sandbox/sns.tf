# Emails
resource "aws_sns_topic" "emails" {
  name = "${var.app}-${var.env}-emails"
}

resource "aws_lambda_permission" "sns_lambda_emails" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.receive_emails.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.emails.arn
}

resource "aws_sns_topic_subscription" "lambda_emails" {
  protocol  = "lambda"
  topic_arn = aws_sns_topic.emails.arn
  endpoint  = aws_lambda_function.receive_emails.arn
}

# AWS Notifications
resource "aws_sns_topic" "notifications" {
  name = "${var.app}-${var.env}-notifications"
}

data "aws_iam_policy_document" "notifications" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.notifications.arn]
  }
}

resource "aws_sns_topic_policy" "notifications" {
  arn    = aws_sns_topic.notifications.arn
  policy = data.aws_iam_policy_document.notifications.json
}
