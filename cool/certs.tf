locals {
  cert_arn = data.terraform_remote_state.userservices_dns.outputs.domainmanager_certificate.arn
}
