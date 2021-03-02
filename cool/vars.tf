#=================================================
#  PROVIDER
#=================================================
variable "github_actions_role" {
  type = string
}

variable "shared_services_role" {
  type = string
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
  default = "ProvisionDomainManager"
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

#=================================================
#  ROUTE 53
#=================================================
variable "internal_route53_record" {
  type = string
}

#=================================================
#  DOCKER
#=================================================
variable "image_url" {
  type = string
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
#  API
#=================================================
variable "api_image_repo" {
  type = string
}

variable "api_image_tag" {
  type = string
}

variable "api_cpu" {
  type = number
}

variable "api_memory" {
  type = number
}

variable "api_desired_count" {
  type = number
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

variable "ui_memory" {
  type = number
}

variable "ui_cpu" {
  type = number
}

variable "ui_desired_count" {
  type = number
}

#=================================================
#  BROWSERLESS
#=================================================
variable "browserless_cpu" {
  type = number
}

variable "browserless_memory" {
  type = number
}

variable "browserless_count" {
  type = number
}
