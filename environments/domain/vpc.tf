

# VPC
module "vpc" {
  source     = "git@github.com:willfarrell/terraform-vpc-module?ref=v0.0.1"
  name       = local.workspace["name"]
  az_count   = local.workspace["az_count"]
  cidr_block = local.workspace["cidr_block"]
  nat_type   = local.workspace["nat_type"]
}

resource "aws_ssm_parameter" "vpc_security_group" {
  name        = "/vpc/security_group"
  description = "VPC Security Group"
  type        = "SecureString"
  value       = module.vpc.id
}

resource "aws_ssm_parameter" "public_subnets" {
  name        = "/vpc/public_subnets"
  description = "VPC public subnets"
  type        = "SecureString"
  value       = join(",", flatten([module.vpc.public_subnet_ids]))
}

resource "aws_ssm_parameter" "private_subnets" {
  name        = "/vpc/private_subnets"
  description = "VPC private subnets"
  type        = "SecureString"
  value       = join(",", flatten([module.vpc.private_subnet_ids]))
}

output "nat_ips" {
  value = module.vpc.public_ips
}

output "nat_billing_suggestion" {
  value = module.vpc.billing_suggestion
}

## Public Subnets

module "bastion" {
  source            = "git@github.com:willfarrell/terraform-ec-modules//bastion?ref=v0.0.1"
  name              = local.workspace["name"]
  instance_type     = local.workspace["bastion_instance_type"]
  vpc_id            = module.vpc.id
  network_acl_id    = module.vpc.network_acl_id
  public_subnet_ids = module.vpc.public_subnet_ids
  iam_user_groups   = local.workspace["bastion_user_group"]
  iam_sudo_groups   = local.workspace["bastion_sudo_group"]
  assume_role_arn   = matchkeys(data.terraform_remote_state.master.bastion_role_arns, keys(data.terraform_remote_state.master.sub_accounts), list(terraform.workspace))[0]
}

output "bastion_ip" {
  value = module.bastion.public_ip
}

output "bastion_billing_suggestion" {
  value = module.bastion.billing_suggestion
}

## Private Subnets

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = module.vpc.id
  service_name    = "com.amazonaws.${local.workspace["region"]}.s3"
  route_table_ids = module.vpc.private_route_table_ids

  policy = <<POLICY
{
  "Statement": [
      {
          "Action": "*",
          "Effect": "Allow",
          "Resource": "*",
          "Principal": "*"
      }
  ]
}
POLICY
}
