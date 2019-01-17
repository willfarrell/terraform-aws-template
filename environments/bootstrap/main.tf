# 1. Manually add terraform user
# 2. Run `tf apply`
# 3. Delete terraform user

terraform {
  backend "s3" {
    bucket         = "terraform-state-${**NAME**}"
    key            = "bootstrap/terraform.tfstate"
    region         = "us-east-1"
    profile        = "${**PROFILE**}"
    dynamodb_table = "terraform-state-${**NAME**}"
  }
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

provider "aws" {
  profile = "${**PROFILE**}-${terraform.workspace}"
  region  = "${local.workspace["region"]}"
}

# make terraform role
resource "aws_iam_role" "admin" {
  name = "admin"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.terraform_remote_state.master.account_id}:root"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
}

/*
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "${local.workspace["role_mfa"]}"
        }
      }
*/

resource "aws_iam_role_policy_attachment" "admin" {
  role       = "${aws_iam_role.admin.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "admin_role_arn" {
  value = "${aws_iam_role.admin.arn}"
}
