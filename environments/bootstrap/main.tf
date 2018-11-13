# 1. Manually add terraform user
# 2. Run `tf deploy`
# 3. Delete terraform user

terraform {
  backend "s3" {
    bucket         = "terraform-state-${var.name}"
    key            = "${terraform.workspace}/bootstrap/terraform.tfstate"
    region         = "us-east-1"
    profile        = "${var.profile}"
    dynamodb_table = "terraform-state-${var.name}"
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
}

# make terraform role
resource "aws_iam_role" "terraform" {
  name = "terraform"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.terraform_remote_state.master.id}:root"
      },
      "Effect": "Allow",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "administrator" {
  role       = "${aws_iam_role.terraform.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "terraform_role_arn" {
  value = "${aws_iam_role.terraform.arn}"
}
