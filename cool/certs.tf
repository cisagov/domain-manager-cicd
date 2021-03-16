locals {
  cert_arn = data.terraform_remote_state.domainmanager_networking.outputs.domainmanager_certificate.arn
}
