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
#  NETWORK
#=================================================
variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}


#=================================================
#  PERMISSIONS
#=================================================
variable "allowed_actions" {
  type    = list(string)
  default = ["s3:*", "route53:*"]
}

#=================================================
#  COGNITO
#=================================================
variable "additional_redirect" {
  type    = string
  default = ""
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
#  ROUTE 53
#=================================================
variable "route53_zone_name" {
  type = string
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

#=================================================
#  SYNC DB Lambda Function
#=================================================
variable "sync_db_memory" {
  type = number
}

variable "sync_db_timeout" {
  type = number
}

variable "sync_db_schedule" {
  type = string
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
