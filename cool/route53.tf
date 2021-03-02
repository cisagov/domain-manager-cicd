locals {
    cool_dns_private_zone = data.terraform_remote_state.sharedservices_networking.outputs.private_zone
}

resource "aws_route53_record" "sharedservices_internal_domainmanager" {
    provider = aws.dns_sharedservices

    zone_id = local.cool_dns_private_zone.zone_id
    name    = var.internal_route53_record
    type = "A"

    alias {
      name = module.alb.alb_dns_name
      zone_id = module.alb.alb_zone_id
      evaluate_target_health = false
    }
}