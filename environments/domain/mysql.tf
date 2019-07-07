# TODO setup users for DB access
# TODO save password in Secrect Manager & rotate
# TODO bug fix ssh_identity_file path issue
module "mysql" {
  source = "git@github.com:willfarrell/terraform-db-modules//rds?ref=v0.3.8"
  name   = local.workspace["name"]
  vpc_id = module.vpc.id

  private_subnet_ids = module.vpc.private_subnet_ids

  type              = local.workspace["mysql_type"]
  instance_type     = local.workspace["mysql_instance_type"]
  node_count        = local.workspace["mysql_node_count"]
  replica_count     = local.workspace["mysql_replica_count"]
  multi_az          = local.workspace["multi_az"]
  apply_immediately = local.workspace["apply_immediately"]

  db_name  = local.workspace["mysql_db_name"]
  username = "root"
  password = "password"

  engine                  = local.workspace["mysql_engine"]
  engine_version          = local.workspace["mysql_engine_version"]
  engine_mode             = local.workspace["mysql_engine_mode"]
  allocated_storage       = local.workspace["mysql_allocated_storage"]
  backup_retention_period = local.workspace["mysql_backup_retention_period"]

  # bootstrap
  ssh_username      = "iam.username"
  ssh_identity_file = "~/.ssh/id_rsa"
  bastion_ip        = module.vpc.bastion_ip

  #bootstrap_folder        = "${local.workspace["mysql_bootstrap_folder"]}"
  security_group_ids = [
    module.bastion.security_group_id
  ]
}

# SSM
resource "aws_ssm_parameter" "mysql_endpoint" {
  name        = "/database/mysql/endpoint"
  description = "Endpoint to connect to the database"
  type        = "SecureString"
  value       = module.mysql.endpoint
}

resource "aws_ssm_parameter" "mysql_endpoints" {
  name        = "/database/mysql/endpoints"
  description = "Endpoints to connect to read the database"
  type        = "SecureString"
  value       = join(",",module.mysql.replica_endpoints)
}

resource "aws_ssm_parameter" "mysql_port" {
  name        = "/database/mysql/port"
  description = "Port to connect to the database"
  type        = "SecureString"
  value       = module.mysql.port
}

resource "aws_ssm_parameter" "mysql_username" {
  name        = "/database/mysql/username"
  description = "Username to connect to the database"
  type        = "SecureString"
  value       = module.mysql.username
}

resource "aws_ssm_parameter" "mysql_password" {
  name        = "/database/mysql/username"
  description = "Username to connect to the database"
  type        = "SecureString"
  value       = module.mysql.password
}

resource "aws_ssm_parameter" "mysql_database" {
  name        = "/database/mysql/database"
  description = "Database to connect to"
  type        = "SecureString"
  value       = module.mysql.database
}

# Output
output "mysql_endpoint" {
  value = module.mysql.endpoint
}

output "mysql_replica_endpoints" {
  value = module.mysql.replica_endpoints
}

output "mysql_billing_suggestion" {
  value = module.mysql.billing_suggestion
}
