
resource "aws_ssm_parameter" "vpc_id" {
  name        = "/vpc/id"
  description = "VPC ID"
  type        = "SecureString"
  value       = "${module.vpc.id}"
}

resource "aws_ssm_parameter" "private_subnets" {
  name        = "/vpc/private_subnets"
  description = "VPC private subnets"
  type        = "SecureString"
  value       = "${join(",", module.vpc.private_subnet_ids)}"
}
