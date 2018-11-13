terraform {
  backend "s3" {
    bucket         = "terraform-state-${var.name}"
    key            = "environment/account/terraform.tfstate"
    region         = "us-east-1"
    profile        = "${var.state_profile}"
    dynamodb_table = "terraform-state-${var.name}"
  }
}

data "terraform_remote_state" "bootstrap" {
  backend = "s3"

  config = {
    bucket  = "terraform-state-${var.name}"
    key     = "${terraform.workspace}/bootstrap/terraform.tfstate"
    region  = "us-east-1"
    profile = "${var.state_profile}"
  }
}

data "terraform_remote_state" "master" {
  backend = "s3"

  config = {
    bucket  = "terraform-state-${var.name}"
    key     = "master/account/terraform.tfstate"
    region  = "us-east-1"
    profile = "${var.profile}"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "${var.profile}"

  assume_role = {
    role_arn = "${data.terraform_remote_state.bootstrap.terraform_role_arn}"
  }
}

module "account" {
  source            = "../../../sub-account"
  name              = "${var.name}"
  master_account_id = "${data.terraform_remote_state.master.account_id}"
  roles             = "${var.roles}"
}

output "account_id" {
  value = "${module.account.id}"
}

output "roles" {
  value = "${module.account.roles}"
}
