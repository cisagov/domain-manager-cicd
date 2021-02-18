terraform {
  backend "s3" {
    bucket         = "inl-tf-backend"
    key            = "dm-cool-provisioner.tf"
    region         = "us-east-1"
    dynamodb_table = "inl-tf-lock"
  }
}
