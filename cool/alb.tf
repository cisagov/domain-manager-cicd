#=================================================
#  APPLICATION LOAD BALANCER
#=================================================
resource "aws_security_group" "alb" {
  name        = "${var.app}-${var.env}-alb-sg"
  description = "Allowed ports into alb"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    "Name" = "${var.app}-${var.env}-alb-sg"
  }, local.tags)
}

module "alb" {
  source              = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=tags/0.28.0"
  namespace           = var.app
  stage               = var.env
  name                = "alb"
  access_logs_enabled = false
  http_enabled        = false
  idle_timeout        = var.idle_timeout
  internal            = true
  vpc_id              = local.vpc_id
  security_group_ids  = [aws_security_group.alb.id]
  subnet_ids          = local.private_subnet_ids
  target_group_name   = "${var.app}-${var.env}-tg"
  tags                = local.tags
}

# # ===================================
# # Listener
# # ===================================
resource "aws_lb_listener" "https" {
  load_balancer_arn = module.alb.alb_arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = local.cert_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "${var.app}-${var.env} fixed response"
      status_code  = 200
    }
  }
}


#=================================================
#  NETWORK LOAD BALANCER
#=================================================
resource "aws_lb" "network" {
  name                             = "${var.app}-${var.env}-network"
  enable_cross_zone_load_balancing = true
  idle_timeout                     = 60
  internal                         = true
  load_balancer_type               = "network"
  subnets                          = local.private_subnet_ids
  tags                             = local.tags
}
