locals {
  ecs_task_role         = "arn:aws:iam::${var.account_id}:role/ExecuteDomainManagerECSTask"
  ecs_execution_role    = "arn:aws:iam::${var.account_id}:role/ExecuteDomainManagerECS"
  lambda_execution_role = "arn:aws:iam::${var.account_id}:role/ExecuteDomainManagerLambda"
}
