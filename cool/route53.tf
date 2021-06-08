data "aws_route53_zone" "zone" {
  count = var.hosted_zone_name == null ? 0 : 1
  name  = var.hosted_zone_name
}

resource "aws_route53_record" "sharedservices_internal_domainmanager" {
    count    = var.is_cool == true ? 1 : 0
    provider = aws.dns_sharedservices

    zone_id = data.terraform_remote_state.sharedservices_networking[0].outputs.private_zone
    name    = var.internal_route53_record
    type    = "A"

    alias {
      name = module.alb.alb_dns_name
      zone_id = module.alb.alb_zone_id
      evaluate_target_health = false
    }
}

resource "aws_route53_record" "sandbox_public_domainmanager" {
  count = var.is_cool == false ? 1 : 0

  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.internal_route53_record
  type    = "A"

  alias {
    name = module.alb.alb_dns_name
    zone_id = module.alb.alb_zone_id
    evaluate_target_health = false
  }
}