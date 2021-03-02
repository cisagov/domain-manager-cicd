provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn     = var.github_actions_role
    session_name = "${var.app}-${var.env}"
  }
}

provider "aws" {
  alias  = "dns_sharedservices"
  region = "us-east-1"

  assume_role {
    role_arn     = var.shared_services_role
    session_name = "${var.app}-${var.env}"
  }
}
