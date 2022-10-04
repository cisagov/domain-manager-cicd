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
  name        = "/${var.env}/${var.app}/docdb/username/master"
  description = "The username for document db"
  type        = "SecureString"
  value       = random_string.docdb_username.result
}

resource "random_password" "docdb_password" {
  length           = 32
  special          = true
  override_special = "!_#&"
}

resource "aws_ssm_parameter" "docdb_password" {
  name        = "/${var.env}/${var.app}/docdb/password/master"
  description = "The password for document db"
  type        = "SecureString"
  value       = random_password.docdb_password.result
}

# ===========================
# DOCUMENT DB
# ===========================
module "documentdb" {
  source                  = "git::https://github.com/cloudposse/terraform-aws-documentdb-cluster.git?ref=tags/0.14.1"
  stage                   = var.env
  namespace               = var.app
  name                    = "docdb"
  cluster_family          = "docdb3.6"
  cluster_size            = var.documentdb_cluster_size
  master_username         = random_string.docdb_username.result
  master_password         = random_password.docdb_password.result
  instance_class          = var.documentdb_instance_class
  vpc_id                  = var.vpc_id
  subnet_ids              = var.private_subnet_ids
  allowed_cidr_blocks     = ["10.0.0.0/8"]
  allowed_security_groups = [aws_security_group.api.id]
  skip_final_snapshot     = true
}

# module "documentdb_cluster" {
#   source  = "cloudposse/documentdb-cluster/aws"
#   version = "0.13.0"

#   stage     = var.env
#   namespace = var.app
#   name      = "db"

#   cluster_family          = "docdb4.0"
#   cluster_size            = var.documentdb_cluster_size
#   master_username         = random_string.docdb_username.result
#   master_password         = random_password.docdb_password.result
#   instance_class          = var.documentdb_instance_class
#   vpc_id                  = var.vpc_id
#   subnet_ids              = var.private_subnet_ids
#   allowed_cidr_blocks     = ["10.0.0.0/8"]
#   allowed_security_groups = [aws_security_group.api.id]
#   skip_final_snapshot     = true
# }

resource "aws_docdb_cluster" "docdb" {
  backup_retention_period = 5
  cluster_identifier      = "db-cluster"
  engine                  = "docdb"
  engine_version          = 4.0
  master_username         = random_string.docdb_username.result
  master_password         = random_password.docdb_password.result
  preferred_backup_window = "21:00-23:00"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [var.vpc.id]
}
