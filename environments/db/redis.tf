module "redis" {
  source = "git@github.com:tesera/terraform-modules//elasticache?ref=v0.2.9"
  name   = "${local.workspace["name"]}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  private_subnet_ids = [
    "${data.terraform_remote_state.vpc.private_subnet_ids}",
  ]

  type              = "${local.workspace["redis_type"]}"
  instance_type     = "${local.workspace["redis_instance_type"]}"
  node_count        = "${local.workspace["redis_node_count"]}"
  replica_count     = "${local.workspace["redis_replica_count"]}"
  multi_az          = "${local.workspace["multi_az"]}"
  apply_immediately = "${local.workspace["apply_immediately"]}"

  engine         = "${local.workspace["redis_engine"]}"
  engine_version = "${local.workspace["redis_engine_version"]}"

  security_group_ids = []

  #"${data.terraform_remote_state.vpc.bastion_security_group_id}",
  #"${data.terraform_remote_state.api.ecs_security_group_id}",
}

resource "aws_ssm_parameter" "redis_arn" {
  name        = "/redis/arn"
  description = "redis ARN"
  type        = "SecureString"
  value       = "${module.mysql.arn}"
}

resource "aws_ssm_parameter" "redis_endpoint" {
  name        = "/redis/endpoint"
  description = "redis Endpoint"
  type        = "SecureString"
  value       = "${module.mysql.endpoint}"
}

resource "aws_ssm_parameter" "redis_replica_endpoints" {
  name        = "/redis/replica_endpoints"
  description = "redis Replica Endpoint"
  type        = "SecureString"
  value       = "${join(",", module.redis.replica_endpoints)}"
}

output "redis_endpoint" {
  value = "${module.redis.endpoint}"
}

output "redis_replica_endpoints" {
  value = "${module.redis.replica_endpoints}"
}

output "redis_security_group_id" {
  value = "${module.redis.security_group_id}"
}
