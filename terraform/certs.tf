# ===========================
# Certs
# ===========================
module "acm" {
  source      = "github.com/terraform-aws-modules/terraform-aws-acm"
  domain_name = aws_route53_record.domain.name
  zone_id     = data.aws_route53_zone.zone.zone_id
}
