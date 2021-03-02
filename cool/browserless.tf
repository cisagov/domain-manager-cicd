locals {
  browserless_port           = 3000
  browserless_name           = "${var.app}-${var.env}-browser"
  browserless_container_name = "browserless"
}

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

# ===========================
# SECURITY GROUP
# ===========================
resource "aws_security_group" "browserless" {
  name        = local.browserless_name
  description = "Allow traffic for browserless chrome from alb"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow traffic to containers"
    from_port   = local.browserless_port
    to_port     = local.browserless_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    "Name" = local.browserless_name
  }, local.tags)
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

# ===========================
# TASK DEFINITION
# ===========================
resource "aws_ecs_task_definition" "browserless" {
  family                   = local.browserless_name
  container_definitions    = module.browserless_container.json_map_encoded_list
  cpu                      = var.browserless_cpu
  execution_role_arn       = local.ecs_execution_role
  memory                   = var.browserless_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = local.ecs_task_role
  tags                     = local.tags
}

# ===========================
# FARGATE SERVICE
# ===========================
resource "aws_ecs_service" "browserless" {
  name            = local.browserless_container_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.browserless.arn
  desired_count   = var.browserless_count
  launch_type     = "FARGATE"
  tags            = local.tags

  load_balancer {
    target_group_arn = aws_lb_target_group.browserless.arn
    container_name   = local.browserless_container_name
    container_port   = local.browserless_port
  }

  network_configuration {
    subnets          = local.private_subnet_ids
    security_groups  = [aws_security_group.browserless.id]
    assign_public_ip = false
  }
}
