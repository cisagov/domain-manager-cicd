# ===========================
# Certs
# ===========================
module "acm" {
  source      = "github.com/terraform-aws-modules/terraform-aws-acm"
  version     = "~> v2.14.0"
  domain_name = aws_route53_record.domain.name
  zone_id     = data.aws_route53_zone.zone.zone_id
}
