locals {
  vpc_id             = data.terraform_remote_state.userservices_networking.outputs.vpc.id
  private_subnet_ids = values(data.terraform_remote_state.userservices_networking.outputs.private_subnets).*.id
  public_subnet_ids  = values(data.terraform_remote_state.userservices_networking.outputs.public_subnets).*.id
}
