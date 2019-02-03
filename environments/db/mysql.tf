# TODO setup users for DB access
# TODO save password in Secrect Manager & rotate
# TODO bug fix ssh_identity_file path issue
module "mysql" {
  source = "git@github.com:tesera/terraform-modules//rds?ref=v0.2.9"
  name   = "${local.workspace["name"]}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  private_subnet_ids = [
    "${data.terraform_remote_state.vpc.private_subnet_ids}",
  ]

  type              = "${local.workspace["mysql_type"]}"
  instance_type     = "${local.workspace["mysql_instance_type"]}"
  node_count        = "${local.workspace["mysql_node_count"]}"
  replica_count     = "${local.workspace["mysql_replica_count"]}"
  multi_az          = "${local.workspace["multi_az"]}"
  apply_immediately = "${local.workspace["apply_immediately"]}"

  db_name  = "${local.workspace["mysql_db_name"]}"
  username = "root"
  password = "password"

  engine                  = "${local.workspace["mysql_engine"]}"
  engine_version          = "${local.workspace["mysql_engine_version"]}"
  engine_mode             = "${local.workspace["mysql_engine_mode"]}"
  allocated_storage       = "${local.workspace["mysql_allocated_storage"]}"
  backup_retention_period = "${local.workspace["mysql_backup_retention_period"]}"

  # bootstrap
  ssh_username      = "iam.username"
  ssh_identity_file = "~/.ssh/id_rsa"
  bastion_ip        = "${data.terraform_remote_state.vpc.bastion_ip}"

  #bootstrap_folder        = "${local.workspace["mysql_bootstrap_folder"]}"
  security_group_ids = []

  #"${data.terraform_remote_state.vpc.bastion_security_group_id}",
  #"${data.terraform_remote_state.api.ecs_security_group_id}",
}

resource "aws_ssm_parameter" "mysql_arn" {
  name        = "/mysql/arn"
  description = "MySQL ARN"
  type        = "SecureString"
  value       = "${module.mysql.arn}"
}

resource "aws_ssm_parameter" "mysql_endpoint" {
  name        = "/mysql/endpoint"
  description = "MySQL Endpoint"
  type        = "SecureString"
  value       = "${module.mysql.endpoint}"
}

resource "aws_ssm_parameter" "mysql_replica_endpoints" {
  name        = "/mysql/replica_endpoints"
  description = "MySQL Replica Endpoint"
  type        = "SecureString"
  value       = "${join(",", module.mysql.replica_endpoints)}"
}

# TODO ssm user/pass

output "mysql_endpoint" {
  value = "${module.mysql.endpoint}"
}

output "mysql_replica_endpoints" {
  value = "${module.mysql.replica_endpoints}"
}

output "mysql_security_group_id" {
  value = "${module.mysql.security_group_id}"
}

output "mysql_billing_suggestion" {
  value = "${module.mysql.billing_suggestion}"
}
