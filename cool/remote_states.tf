data "terraform_remote_state" "domainmanager_networking" {
  count = var.is_cool == true ? 1 : 0
  
  backend = "s3"

  config = {
    encrypt        = true
    bucket         = "cisa-cool-terraform-state"
    dynamodb_table = "terraform-state-lock"
    region         = "us-east-1"
    key            = "cool-domain-manager-networking/terraform.tfstate"
    role_arn       = "arn:aws:iam::210193616405:role/ReadDomainManagerNetworkingTerraformState"
    session_name   = "${var.app}-${var.env}"
  }

  workspace = var.workspace_type
}

data "terraform_remote_state" "sharedservices_networking" {
  count = var.is_cool == true ? 1 : 0

  backend = "s3"

  config = {
    encrypt        = true
    bucket         = "cisa-cool-terraform-state"
    dynamodb_table = "terraform-state-lock"
    region         = "us-east-1"
    key            = "cool-sharedservices-networking/terraform.tfstate"
    role_arn       = "arn:aws:iam::210193616405:role/ReadSharedServicesNetworkingTerraformState"
    session_name   = "${var.app}-${var.env}"
  }

  workspace = var.workspace_type
}
