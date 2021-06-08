#=================================================
#  PROVIDER
#=================================================
variable "shared_services_account_id" {
  type = string
  description = "Account ID for DNS shared services role."
}

variable "workspace_type" {
  type = string
}

variable "account_id" {
  type = string
}

#=================================================
#  PROVISION ACCOUNT
#=================================================
variable "provision_account_role_name" {
  type    = string
  default = "ProvisionAccount"
}

#=================================================
#  CORE
#=================================================
variable "env" {
  type = string
}

variable "app" {
  type = string
}

variable "region" {
  type = string
}

variable "is_cool" {
  type        = bool
  default     = true
  description = "Whether environment is in the COOL."
}

#=================================================
#  NETWORKING
#=================================================
variable "vpc_id" {
  type        = string
  default     = null
  description = "Optional VPC Id to provide, otherwise uses remote state."
}

variable "private_subnet_ids" {
  type        = list(string)
  default     = null
  description = "Optional private subnet ids to provide, otherwise uses remote state."
}

variable "public_subnet_ids" {
  type        = list(string)
  default     = null
  description = "Optional public subnet ids to provide, otherwise uses remote state."
}

#=================================================
#  EMAILS NOTIFICATIONS
#=================================================
variable "ses_arn" {
  type        = string
  description = "ARN for sending email through SES"
}

variable "ses_from" {
  type        = string
  description = "From email address for notifications"
}

variable "new_user_notification_email_address" {
  type        = string
  description = "An admin email group for notifiying when a new user is registered"
}

#=================================================
#  ROUTE 53
#=================================================
variable "hosted_zone_name" {
  type        = string
  default     = null
  description = "Name of hosted zone if running outside of COOL."
}

variable "internal_route53_record" {
  type        = string
  description = "Route53 record name to access application."
}

#=================================================
#  LOGS
#=================================================
variable "log_retention_days" {
  type = number
}

#=================================================
#  LOAD BALANCING
#=================================================
variable "idle_timeout" {
  type    = number
  default = 600
}

#=================================================
#  DOCUMENTDB
#=================================================
variable "documentdb_cluster_size" {
  type = number
}

variable "documentdb_instance_class" {
  type = string
}

#=================================================
#  Resources
#=================================================
variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "desired_count" {
  type= number
}

#=================================================
#  API
#=================================================
variable "api_image_repo" {
  type = string
}

variable "api_image_tag" {
  type = string
}

#=================================================
#  UI
#=================================================
variable "ui_image_repo" {
  type = string
}

variable "ui_image_tag" {
  type = string
}
