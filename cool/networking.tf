locals {
  vpc_id             = data.terraform_remote_state.domainmanager_networking.outputs.vpc.id
  private_subnet_ids = values(data.terraform_remote_state.domainmanager_networking.outputs.private_subnets).*.id
  public_subnet_ids  = values(data.terraform_remote_state.domainmanager_networking.outputs.public_subnets).*.id
}
