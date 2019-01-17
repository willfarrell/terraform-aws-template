terraform {
  backend "s3" {
    bucket         = "terraform-state-${**NAME**}"
    key            = "account/terraform.tfstate"
    region         = "us-east-1"
    profile        = "${**PROFILE**}"
    dynamodb_table = "terraform-state-${**NAME**}"
    encrypt        = true
  }
}

provider "aws" {
  profile = "${**PROFILE**}-${terraform.workspace}"
  region  = "${local.workspace["region"]}"
}

module "apig-logs" {
  source = "git@github.com:tesera/terraform-modules//account/api-gateway?ref=v0.2.1"
}

data "terraform_remote_state" "master" {
  backend = "s3"

  config = {
    bucket  = "terraform-state-${**NAME**}"
    key     = "master/account/terraform.tfstate"
    region  = "us-east-1"
    profile = "${**PROFILE**}"
  }
}

//module "account" {
//  source            = "../../../sub-account"
//  name              = "${local.workspace["name"]}"
//  master_account_id = "${data.terraform_remote_state.master.account_id}"
//  roles             = "${var.roles}"
//}

