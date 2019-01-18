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
  profile = "sensnet-${terraform.workspace}"
  region  = "${local.workspace["region"]}"
}

# VPC
module "vpc" {
  source     = "git@github.com:tesera/terraform-modules//vpc?ref=v0.2.4"
  name       = "${local.workspace["name"]}"
  az_count   = "${local.workspace["az_count"]}"
  cidr_block = "${local.workspace["cidr_block"]}"
  nat_type   = "${local.workspace["nat_type"]}"
}

## Public Subnets

data "terraform_remote_state" "master" {
  backend = "s3"

  config = {
    bucket  = "terraform-state-${**NAME**}"
    key     = "master/account/terraform.tfstate"
    region  = "us-east-1"
    profile = "${**PROFILE**}"
  }
}

module "bastion" {
  source            = "git@github.com:tesera/terraform-modules//bastion?ref=v0.2.4"
  name              = "${local.workspace["name"]}"
  instance_type     = "${local.workspace["bastion_instance_type"]}"
  vpc_id            = "${module.vpc.id}"
  network_acl_id    = "${module.vpc.network_acl_id}"
  public_subnet_ids = "${module.vpc.public_subnet_ids}"
  iam_user_groups   = "${local.workspace["bastion_user_group"]}"
  iam_sudo_groups   = "${local.workspace["bastion_sudo_group"]}"
  assume_role_arn   = "${element(matchkeys(data.terraform_remote_state.master.bastion_role_arns, keys(data.terraform_remote_state.master.sub_accounts), list(terraform.workspace)),0)}"
}

output "bastion_ip" {
  value = "${module.bastion.public_ip}"
}

output "bastion_security_group_id" {
  value = "${module.bastion.security_group_id}"
}

output "bastion_billing_suggestion" {
  value = "${module.bastion.billing_suggestion}"
}

## Private Subnets

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = "${module.vpc.id}"
  service_name      = "com.amazonaws.${local.workspace["region"]}.s3"
  route_table_ids   = ["${module.vpc.private_route_table_ids}"]
  policy            = <<POLICY
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

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id          = "${module.vpc.id}"
  service_name    = "com.amazonaws.${local.workspace["region"]}.dynamodb"
  route_table_ids = ["${module.vpc.private_route_table_ids}"]
  policy          = <<POLICY
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
