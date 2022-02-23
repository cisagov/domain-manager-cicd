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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    "Name" = "${var.app}-${var.env}-alb-sg"
  }, local.tags)
}

resource "aws_lb" "alb" {
  name               = "${var.app}-${var.env}-internal"
  idle_timeout       = var.idle_timeout
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = local.private_subnet_ids
}


# # ===================================
# # Listener
# # ===================================
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
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
