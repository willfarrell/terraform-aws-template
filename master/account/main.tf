terraform {
  backend "s3" {
    bucket         = "terraform-state-${**NAME**}"
    key            = "master/account/terraform.tfstate"
    region         = "us-east-1"
    profile        = "${**PROFILE**}"
    dynamodb_table = "terraform-state-${**NAME**}"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "${var.profile}"
}

module "defaults" {
  source = "git@github.com:tesera/terraform-modules//defaults?ref=v0.1.2"
}

//modules "master" { /* sub account generation */ }

module "groups" {
  source       = "git@github.com:tesera/terraform-modules//groups?ref=v0.1.3"
  sub_accounts = "${var.sub_accounts}"

  roles = [
    "admin",
  ]
}

module "bastion_roles" {
  source       = "git@github.com:tesera/terraform-modules//bastion-roles?ref=v0.1.4"
  sub_accounts = "${var.sub_accounts}"
}

//module "users" {
//  source = "../../modules/users"
//  users = {
//    "will.farrell" = ["DevelopmentTerraform"]
//    "test.a" = ["DevelopmentTerraform"]
//    "test.b" = ["DevelopmentTerraform"]
//  }
//}

