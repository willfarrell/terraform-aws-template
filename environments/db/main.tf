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
  profile = "${**PROFILE**}-${local.workspace["env"]}"
  region  = "${local.workspace["region"]}"
}

## States
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket  = "terraform-state-${**NAME**}"
    key     = "vpc/terraform.tfstate"
    region  = "us-east-1"
    profile = "${**PROFILE**}"
  }
}
