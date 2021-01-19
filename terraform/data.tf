# ===========================
# ROUTE 53
# ===========================
data "aws_route53_zone" "zone" {
  name = var.route53_zone_name
}

data "aws_ssm_parameter" "two_captcha" {
  name = "/${var.env}/${var.app}/2captcha/key"
}
