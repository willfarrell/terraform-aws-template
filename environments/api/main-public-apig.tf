terraform {
  backend "s3" {
    bucket         = "terraform-state-${**NAME**}"
    key            = "api/terraform.tfstate"
    region         = "us-east-1"
    profile        = "${**PROFILE**}"
    dynamodb_table = "terraform-state-${**NAME**}"
    encrypt        = true // TODO everywhere
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
  domain   = "${local.workspace["domain"]}"

  statuses = [
    "ISSUED",
  ]
}
