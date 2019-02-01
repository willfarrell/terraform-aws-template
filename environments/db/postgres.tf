# TODO setup users for DB access
# TODO save password in Secrect Manager & rotate
# TODO bug fix ssh_identity_file path issue
module "postgres" {
  source = "git@github.com:tesera/terraform-modules//rds?ref=v0.2.9"
  name   = "${local.workspace["name"]}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  private_subnet_ids = [
    "${data.terraform_remote_state.vpc.private_subnet_ids}",
  ]

  type              = "${local.workspace["postgres_type"]}"
  instance_type     = "${local.workspace["postgres_instance_type"]}"
  node_count        = "${local.workspace["postgres_node_count"]}"
  replica_count     = "${local.workspace["postgres_replica_count"]}"
  multi_az          = "${local.workspace["multi_az"]}"
  apply_immediately = "${local.workspace["apply_immediately"]}"

  db_name  = "${local.workspace["postgres_db_name"]}"
  username = "root"
  password = "password"

  engine                  = "${local.workspace["postgres_engine"]}"
  engine_version          = "${local.workspace["postgres_engine_version"]}"
  engine_mode             = "${local.workspace["postgres_engine_mode"]}"
  allocated_storage       = "${local.workspace["postgres_allocated_storage"]}"
  backup_retention_period = "${local.workspace["postgres_backup_retention_period"]}"

  # bootstrap
  ssh_username      = "iam.username"
  ssh_identity_file = "~/.ssh/id_rsa"
  bastion_ip        = "${data.terraform_remote_state.vpc.bastion_ip}"

  #bootstrap_folder        = "${local.workspace["postgres_bootstrap_folder"]}"
  security_group_ids = []

  #"${data.terraform_remote_state.vpc.bastion_security_group_id}",
  #"${data.terraform_remote_state.api.ecs_security_group_id}",
}

resource "aws_ssm_parameter" "postgres_endpoint" {
  name        = "/postgres/endpoint"
  description = "PostgreSQL Endpoint"
  type        = "SecureString"
  value       = "${module.mysql.endpoint}"
}

resource "aws_ssm_parameter" "postgres_replica_endpoints" {
  name        = "/postgres/replica_endpoints"
  description = "PostgreSQL Replica Endpoint"
  type        = "SecureString"
  value       = "${join(",", module.postgres.replica_endpoints)}"
}

# TODO ssm user/pass

output "postgres_endpoint" {
  value = "${module.postgres.endpoint}"
}

output "postgres_replica_endpoints" {
  value = "${module.postgres.replica_endpoints}"
}

output "postgres_security_group_id" {
  value = "${module.postgres.security_group_id}"
}

output "postgres_billing_suggestion" {
  value = "${module.postgres.billing_suggestion}"
}
