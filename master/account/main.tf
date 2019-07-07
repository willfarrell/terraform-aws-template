terraform {
  backend "s3" {
    bucket         = "terraform-state-{**NAME**}"
    key            = "master/account/terraform.tfstate"
    region         = "us-east-1"
    profile        = "{**PROFILE**}"
    dynamodb_table = "terraform-state-{**NAME**}"
  }
}

provider "aws" {
  region  = local.workspace['region']
  profile = local.workspace['profile']
}

module "groups" {
  source       = "git@github.com:willfarrell/terraform-account-modules//groups?ref=v0.0.1"
  type         = "master"
  sub_accounts = local.workspace['sub_accounts']
}

module "roles" {
  source       = "git@github.com:willfarrell/terraform-account-modules//roles?ref=v0.0.1"
  type         = "master"
  sub_accounts = local.workspace['sub_accounts']
}

# Output
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "sub_accounts" {
  value = local.workspace['sub_accounts']
}

output "groups" {
  value = module.groups.list
}

output "role_arns" {
  value = module.roles.arns
}
