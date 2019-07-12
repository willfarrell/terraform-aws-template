terraform {
  backend "s3" {
    bucket         = "terraform-state-{**NAME**}"
    key            = "account/terraform.tfstate"
    region         = "us-east-1"
    profile        = "{**PROFILE**}"
    dynamodb_table = "terraform-state-{**NAME**}"
    encrypt        = true
  }
}

# On first run have terraform user creds attached to profile
# change credentials for assume role for future runs
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
