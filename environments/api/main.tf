terraform {
  required_version = ">= 0.11.0"

  backend "s3" {
    bucket         = "terraform-state-"
    key            = "api/terraform.tfstate"
    region         = "us-east-1"
    profile        = "tesera"
    dynamodb_table = "terraform-state-"
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

provider "aws" {
  region      = "${var.aws_region}"
  profile     = "${var.profile}"
  assume_role = "${data.terraform_remote_state.bootstrap.terraform_role_arn}"
}

provider "aws" {
  region      = "us-east-1"
  profile     = "${var.profile}"
  alias       = "edge"
  assume_role = "${data.terraform_remote_state.bootstrap.terraform_role_arn}"
}

## States
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket  = "terraform-state"
    key     = "vpc/terraform.tfstate"
    region  = "us-east-1"
    profile = "${var.profile}"
  }
}

## API

