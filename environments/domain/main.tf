terraform {
  backend "s3" {
    bucket         = "terraform-state-${**NAME**}"
    key            = "${**DOMAIN**}/terraform.tfstate"
    region         = "us-east-1"
    profile        = "${**PROFILE**}"
    dynamodb_table = "terraform-state-${**NAME**}"
    encrypt        = true
  }
}

provider "aws" {
  profile = "${local.workspace["profile"]}-${local.workspace["env"]}"
  region  = local.workspace["region"]
}

provider "aws" {
  profile = "${local.workspace["profile"]}-${local.workspace["env"]}"
  region  = "us-east-1"
  alias   = "edge"
}

data "terraform_remote_state" "master" {
  backend = "s3"

  config = {
    bucket  = "terraform-state-${**NAME**}"
    key     = "master/account/terraform.tfstate"
    region  = "us-east-1"
    profile = local.workspace["profile"]
  }
}
