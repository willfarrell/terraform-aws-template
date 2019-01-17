terraform {
  backend "s3" {
    bucket         = "terraform-state-${**NAME**}"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    profile        = "${**PROFILE**}"
    dynamodb_table = "terraform-state-${**NAME**}"
  }
}

provider "aws" {
  profile = "${**PROFILE**}-${local.workspace["env"]}"
  region  = "${local.workspace["region"]}"
}

## States
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket  = "terraform-state-${**NAME**}"
    key     = "vpc/terraform.tfstate"
    region  = "us-east-1"
    profile = "${**PROFILE**}"
  }
}

## Database(s)
module "cache" {
  source = "git@github.com:tesera/terraform-modules//elasticache?ref=v0.2.9"
  name   = "${local.workspace["name"]}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  private_subnet_ids = [
    "${data.terraform_remote_state.vpc.private_subnet_ids}",
  ]

  type              = "${local.workspace["cache_type"]}"
  instance_type     = "${local.workspace["cache_instance_type"]}"
  node_count        = "${local.workspace["cache_node_count"]}"
  replica_count     = "${local.workspace["cache_replica_count"]}"
  multi_az          = "${local.workspace["multi_az"]}"
  apply_immediately = "${local.workspace["apply_immediately"]}"

  engine         = "${local.workspace["cache_engine"]}"
  engine_version = "${local.workspace["cache_engine_version"]}"

  security_group_ids = []

  #"${data.terraform_remote_state.vpc.bastion_security_group_id}",
  #"${data.terraform_remote_state.api.ecs_security_group_id}",
}

output "cache_endpoint" {
  value = "${module.cache.endpoint}"
}

output "cache_replica_endpoints" {
  value = "${module.cache.replica_endpoints}"
}

output "cache_security_group_id" {
  value = "${module.cache.security_group_id}"
}

module "elastic" {
  source = "git@github.com:tesera/terraform-modules//elasticsearch?ref=v0.2.9"
  name   = "${local.workspace["name"]}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  private_subnet_ids = [
    "${data.terraform_remote_state.vpc.private_subnet_ids}",
  ]

  #type                = "${local.workspace["elastic_type"]}"           # N/A
  instance_type = "${local.workspace["elastic_instance_type"]}"
  node_count    = "${local.workspace["relastic_node_count"]}"

  #engine              = "${local.workspace["elastic_engine"]}"          # N/A
  engine_version = "${local.workspace["elastic_engine_version"]}"

  # bootstrap
  ssh_username      = "iam.username"
  ssh_identity_file = "~/.ssh/id_rsa"
  bastion_ip        = "${data.terraform_remote_state.vpc.bastion_ip}"

  #bootstrap_file      = "${local.workspace["elastic_bootstrap_file"]}"
  security_group_ids = [
    "${data.terraform_remote_state.vpc.bastion_security_group_id}",
  ]
}

output "elastic_endpoint" {
  value = "${module.elastic.endpoint}"
}

output "elastic_security_group_id" {
  value = "${module.elastic.security_group_id}"
}

# TODO setup users for DB access
# TODO save password in Secrect Manager & rotate
# TODO bug fix ssh_identity_file path issue
module "rds" {
  source = "git@github.com:tesera/terraform-modules//rds?ref=v0.2.9"
  name   = "${local.workspace["name"]}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  private_subnet_ids = [
    "${data.terraform_remote_state.vpc.private_subnet_ids}",
  ]

  type              = "${local.workspace["rds_type"]}"
  instance_type     = "${local.workspace["rds_instance_type"]}"
  node_count        = "${local.workspace["rds_node_count"]}"
  replica_count     = "${local.workspace["rds_replica_count"]}"
  multi_az          = "${local.workspace["multi_az"]}"
  apply_immediately = "${local.workspace["apply_immediately"]}"

  db_name  = "${local.workspace["rds_db_name"]}"
  username = "root"
  password = "password"

  engine                  = "${local.workspace["rds_engine"]}"
  engine_version          = "${local.workspace["rds_engine_version"]}"
  engine_mode             = "${local.workspace["rds_engine_mode"]}"
  allocated_storage       = "${local.workspace["rds_allocated_storage"]}"
  backup_retention_period = "${local.workspace["rds_backup_retention_period"]}"

  # bootstrap
  ssh_username      = "iam.username"
  ssh_identity_file = "~/.ssh/id_rsa"
  bastion_ip        = "${data.terraform_remote_state.vpc.bastion_ip}"

  #bootstrap_folder        = "${local.workspace["rds_bootstrap_folder"]}"
  security_group_ids = []

  #"${data.terraform_remote_state.vpc.bastion_security_group_id}",
  #"${data.terraform_remote_state.api.ecs_security_group_id}",
}

output "rds_endpoint" {
  value = "${module.rds.endpoint}"
}

output "rds_replica_endpoints" {
  value = "${module.rds.replica_endpoints}"
}

output "rds_security_group_id" {
  value = "${module.rds.security_group_id}"
}

output "rds_billing_suggestion" {
  value = "${module.rds.billing_suggestion}"
}
