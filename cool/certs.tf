locals {
  cert_arn = var.is_cool == true ? data.terraform_remote_state.domainmanager_networking[0].outputs.domainmanager_certificate.arn : module.acm.acm_certificate_arn
}

module "acm" {
  source             = "terraform-aws-modules/acm/aws"
  version            = "~> v2.14.0"
  create_certificate = var.is_cool == false ? 1 : 0
  domain_name        = aws_route53_record.sharedservices_internal_domainmanager.name
  zone_id            = data.aws_route53_zone.zone[0].zone_id
}