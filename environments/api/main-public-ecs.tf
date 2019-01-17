terraform {
  backend "s3" {
    bucket         = "terraform-state-${**NAME**}"
    key            = "api/terraform.tfstate"
    region         = "us-east-1"
    profile        = "${**PROFILE**}"
    dynamodb_table = "terraform-state-${**NAME**}"
    encrypt        = true                          // TODO everywhere
  }
}

provider "aws" {
  profile = "${**PROFILE**}-${terraform.workspace}"
  region  = "${local.workspace["region"]}"
}

provider "aws" {
  profile = "${**PROFILE**}-${terraform.workspace}"
  region  = "us-east-1"
  alias   = "edge"
}

## States
data "terraform_remote_state" "vpc" {
  backend   = "s3"
  workspace = "${local.workspace["env"]}"

  config {
    bucket  = "terraform-state-${**NAME**}"
    key     = "vpc/terraform.tfstate"
    region  = "us-east-1"
    profile = "${**PROFILE**}"
  }
}

# Cert
data "aws_acm_certificate" "main" {
  domain = "${local.workspace["domain"]}"

  statuses = [
    "ISSUED",
  ]
}

# WAF
module "waf" {
  source        = "git@github.com:tesera/terraform-modules//waf-region-owasp?ref=v0.2.4"
  name          = "${local.workspace["name"]}"
  defaultAction = "ALLOW"
}

# ALB
module "alb" {
  source = "../../modules/alb"
  name   = "${local.workspace["name"]}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  private_subnet_ids = [
    "${data.terraform_remote_state.vpc.private_subnet_ids}",
  ]

  waf_acl_id      = "${module.waf.id}"
  https_only      = false
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${data.aws_acm_certificate.main.arn}"

  # ecs
  port                   = 3000
  autoscaling_group_name = "${module.ecs.autoscaling_group_id}"
  security_group_id      = "${module.ecs.security_group_id}"
}

output "alb_endpoint" {
  value = "${module.alb.endpoint}"
}

output "alb_target_group_arn" {
  value = "${module.alb.target_group_arn}"
}

# ECS
module "ecs" {
  source = "git@github.com:tesera/terraform-modules//ecs?ref=v0.2.7"
  name   = "${local.workspace["name"]}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  private_subnet_ids = [
    "${data.terraform_remote_state.vpc.private_subnet_ids}",
  ]

  instance_type    = "${local.workspace["instance_type"]}"
  min_size         = "${local.workspace["min_size"]}"
  max_size         = "${local.workspace["max_size"]}"
  desired_capacity = "${local.workspace["desired_capacity"]}"

  # Will need to comment out `efs` on initial apply TODO BUG
  efs_ids = [
    "${module.efs.efs_id}",
  ]

  efs_security_group_ids = [
    "${module.efs.security_group_id}",
  ]
}

output "ecs_id" {
  value = "module.ecs.id"
}

output "ecs_iam_role_arn" {
  value = "${module.ecs.iam_role_arn}"
}

output "ecs_security_group_id" {
  value = "${module.ecs.security_group_id}"
}

output "ecs_billing_suggestion" {
  value = "${module.ecs.billing_suggestion}"
}

# EFS
module "efs" {
  source = "git@github.com:tesera/terraform-modules//efs?ref=v0.2.4"
  name   = "${local.workspace["name"]}-ecs"

  subnet_ids = [
    "${data.terraform_remote_state.vpc.private_subnet_ids}",
  ]
}

# TODO sg - allow proxy access from bastion to private ports
# TODO VPN


# TODO APIG

