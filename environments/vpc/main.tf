terraform {
  backend "s3" {
    bucket         = "terraform-state-${var.name}"
    key            = "${var.environment}/vpc/terraform.tfstate"
    region         = "us-east-1"
    profile        = "${var.profile}"
    dynamodb_table = "terraform-state-${var.name}"
  }
}

provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.profile}"

  assume_role = {
    role_arn = "arn:aws:iam::${var.account_id}:role/admin"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "${var.profile}"
  alias   = "edge"

  assume_role = {
    role_arn = "arn:aws:iam::${var.account_id}:role/admin"
  }
}

# VPC
module "vpc" {
  source     = ""
  name       = "${var.name}"
  az_count   = "1"
  cidr_block = "10.5.0.0/16"
}

## Public Subnets
### Bastion
//module "bastion" {
//  source            = "bastion"
//  name              = "${var.name}"
//  vpc_id            = "${module.vpc.id}"
//  public_subnet_ids = "${module.vpc.public_subnet_ids}"
//  key_name          = "${local.key_name}"
//  iam_user_groups   = "Admin"
//}
//
//output "bastion_ip" {
//  value = "${module.bastion.public_ip}"
//}
//
//output "bastion_billing_suggestion" {
//  value = "${module.bastion.billing_suggestion}"
//}


## Private Subnets
//resource "aws_vpc_endpoint" "s3" {
//  vpc_id          = "${module.vpc.id}"
//  service_name    = "com.amazonaws.${var.aws_region}.s3"
//  route_table_ids = [
//    "${module.vpc.private_route_table_ids}"]
//}

