
resource "aws_ssm_parameter" "vpc_security_group" {
  name        = "/vpc/security_group"
  description = "VPC Security Group"
  type        = "SecureString"
  value       = "${module.vpc.id}"
}

resource "aws_ssm_parameter" "private_subnets" {
  name        = "/vpc/private_subnets"
  description = "VPC private subnets"
  type        = "SecureString"
  value       = "${join(",", module.vpc.private_subnet_ids)}"
}
