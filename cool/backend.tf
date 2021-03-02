terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "cisa-cool-terraform-state"
    dynamodb_table = "terraform-state-lock"
    region         = "us-east-1"
    key            = "domain-manager-cicd/terraform.tfstate"
    role_arn       = "arn:aws:iam::210193616405:role/AccessDomainManagerTerraformBackend"
    session_name   = "domain-manager-github-actions"
  }
}
