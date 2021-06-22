locals {
  ui_container_port     = 80
  ui_container_name     = "ui"
  ui_container_protocol = "HTTP"
  ui_load_balancer_port = 443
  ui_name               = "${var.app}-${var.env}-ui"

  ui_environment = {
    "API_URL" : "https://${aws_route53_record.sharedservices_internal_domainmanager.name}"
    "DEPLOYED_DATE" : var.deployed_date
    "UI_COMMIT_ID" : var.ui_image_tag
  }
}

# ===========================
# CLOUDWATCH LOGS
# ===========================
resource "aws_cloudwatch_log_group" "ui" {
  name              = local.ui_name
  retention_in_days = var.log_retention_days
  tags              = local.tags
}

# ===========================
# CONTAINER DEFINITION
# ===========================
module "ui_container" {
  source          = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.47.0"
  container_name  = local.ui_container_name
  container_image = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ui_image_repo}:${var.ui_image_tag}"
  essential       = "true"
  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-region        = var.region
      awslogs-group         = aws_cloudwatch_log_group.ui.name
      awslogs-stream-prefix = "/ecs/${local.ui_container_name}"
    }
  }
  port_mappings = [
    {
      containerPort = local.ui_container_port
      hostPort      = local.ui_container_port
      protocol      = "tcp"
    }
  ]

  environment = [
    for key in keys(local.ui_environment) :
    {
      name  = key
      value = local.ui_environment[key]
    }
  ]
}
