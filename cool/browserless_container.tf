locals {
  browserless_port           = 3000
  browserless_name           = "${var.app}-${var.env}-browser"
  browserless_container_name = "browserless"
}

# ===========================
# CLOUDWATCH LOGS
# ===========================
resource "aws_cloudwatch_log_group" "browserless" {
  name              = local.browserless_name
  retention_in_days = var.log_retention_days
  tags              = local.tags
}

# ===========================
# CONTAINER DEFINITION
# ===========================
module "browserless_container" {
  source          = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.47.0"
  container_name  = local.browserless_container_name
  container_image = "browserless/chrome:latest"
  essential       = "true"
  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-region        = var.region
      awslogs-group         = aws_cloudwatch_log_group.browserless.name
      awslogs-stream-prefix = "/ecs/${local.browserless_container_name}"
    }
  }

  port_mappings = [
    {
      containerPort = local.browserless_port
      hostPort      = local.browserless_port
      protocol      = "tcp"
    }
  ]

  environment = [
    {
      name  = "MAX_CONCURRENT_SESSIONS"
      value = 10
    }
  ]
}
