resource "aws_ssm_parameter" "two_captcha" {
  name        = "/${var.app}/${var.env}/2captcha/key"
  description = "api key for 2captcha"
  type        = "SecureString"
  value       = "changeme"
  tags        = local.tags

  lifecycle {
    ignore_changes = [value]
  }
}
