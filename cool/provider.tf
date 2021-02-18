provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::780016325729:role/dm-cool-test-provision"
    session_name = "dm-cool-test"
  }
}
