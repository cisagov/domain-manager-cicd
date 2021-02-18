# ===================================
# Route 53
# ===================================
resource "aws_route53_zone" "zone" {
  name = "cool.${var.env}.${var.route53_zone_name}"
  tags = local.tags
}


resource "aws_route53_record" "domain" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "${var.app}.${aws_route53_zone.zone.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [module.alb.alb_dns_name]
}
