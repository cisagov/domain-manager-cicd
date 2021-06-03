# ===========================
# TARGET GROUP
# ===========================
resource "aws_lb_target_group" "browserless" {
  name        = local.browserless_name
  port        = local.browserless_port
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = local.vpc_id
  tags        = local.tags

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    port                = local.browserless_port
    protocol            = "TCP"
  }
}

# ===========================
# ALB LISTENER
# ===========================
resource "aws_lb_listener" "browserless" {
  load_balancer_arn = aws_lb.network.arn
  port              = local.browserless_port
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.browserless.arn
    type             = "forward"
  }
}