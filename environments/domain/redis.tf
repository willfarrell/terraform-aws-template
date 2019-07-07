module "redis" {
  source = "git@github.com:willfarrell/terraform-db-modules//elasticache?ref=v0.2.9"
  name   = local.workspace["name"]
  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  type              = local.workspace["redis_type"]
  instance_type     = local.workspace["redis_instance_type"]
  node_count        = local.workspace["redis_node_count"]
  replica_count     = local.workspace["redis_replica_count"]
  multi_az          = local.workspace["multi_az"]
  apply_immediately = local.workspace["apply_immediately"]

  engine         = local.workspace["redis_engine"]
  engine_version = local.workspace["redis_engine_version"]

  security_group_ids = []

  #"${data.terraform_remote_state.vpc.bastion_security_group_id}",
  #"${data.terraform_remote_state.api.ecs_security_group_id}",
}

# SSM
resource "aws_ssm_parameter" "redis_endpoint" {
  name        = "/database/redis/endpoint"
  description = "Endpoint to connect to the database"
  type        = "SecureString"
  value       = module.redis.endpoint
}

resource "aws_ssm_parameter" "redis_endpoints" {
  name        = "/database/redis/endpoints"
  description = "Endpoints to connect to read the database"
  type        = "SecureString"
  value       = join(",",module.redis.replica_endpoints)
}

resource "aws_ssm_parameter" "redis_port" {
  name        = "/database/redis/port"
  description = "Port to connect to the database"
  type        = "SecureString"
  value       = module.redis.port
}

# Output
output "redis_endpoint" {
  value = module.redis.endpoint
}

output "redis_replica_endpoints" {
  value = module.redis.replica_endpoints
}

output "redis_security_group_id" {
  value = module.redis.security_group_id
}
