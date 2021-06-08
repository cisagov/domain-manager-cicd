locals {
  vpc_id             = var.vpc_id == null ? data.terraform_remote_state.domainmanager_networking[0].outputs.vpc.id : var.vpc_id
  private_subnet_ids = var.private_subnet_ids == null ? values(data.terraform_remote_state.domainmanager_networking[0].outputs.private_subnets).*.id : var.private_subnet_ids
  public_subnet_ids  = var.public_subnet_ids == null ? values(data.terraform_remote_state.domainmanager_networking[0].outputs.public_subnets).*.id : var.public_subnet_ids
}
