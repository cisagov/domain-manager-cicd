# ===========================
# DOCDB CREDS
# ===========================
resource "random_string" "docdb_username" {
  length  = 8
  number  = false
  special = false
  upper   = false
}

resource "aws_ssm_parameter" "docdb_username" {
  name        = "/${var.app}/${var.env}/docdb/username/master"
  description = "The username for document db"
  type        = "SecureString"
  value       = random_string.docdb_username.result
  tags        = local.tags
}

resource "random_password" "docdb_password" {
  length           = 32
  special          = true
  override_special = "!_#&"
}

resource "aws_ssm_parameter" "docdb_password" {
  name        = "/${var.app}/${var.env}/docdb/password/master"
  description = "The password for document db"
  type        = "SecureString"
  value       = random_password.docdb_password.result
  tags        = local.tags
}

# ===========================
# DOCUMENT DB
# ===========================
module "documentdb" {
  source                  = "git::https://github.com/cloudposse/terraform-aws-documentdb-cluster.git?ref=tags/0.8.0"
  stage                   = var.env
  namespace               = var.app
  name                    = "docdb"
  cluster_size            = var.documentdb_cluster_size
  master_username         = random_string.docdb_username.result
  master_password         = random_password.docdb_password.result
  instance_class          = var.documentdb_instance_class
  vpc_id                  = local.vpc_id
  subnet_ids              = local.private_subnet_ids
  allowed_security_groups = [aws_security_group.service.id]
  skip_final_snapshot     = true
  tags                    = local.tags
}

module "docdb" {
  source                  = "git::https://github.com/cloudposse/terraform-aws-documentdb-cluster.git?ref=tags/0.13.0"
  stage                   = var.env
  namespace               = var.app
  name                    = "docdb4"
  cluster_size            = var.documentdb_cluster_size
  cluster_family          = "docdb4.0"
  master_username         = random_string.docdb_username.result
  master_password         = random_password.docdb_password.result
  instance_class          = var.documentdb_instance_class
  vpc_id                  = local.vpc_id
  subnet_ids              = local.private_subnet_ids
  allowed_security_groups = [aws_security_group.service.id]
  skip_final_snapshot     = true
  tags                    = local.tags
}
