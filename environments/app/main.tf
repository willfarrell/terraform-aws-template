terraform {
  backend "s3" {
    bucket         = "terraform-state-${**NAME**}"
    key            = "app/terraform.tfstate"
    region         = "us-east-1"
    profile        = "${**PROFILE**}"
    dynamodb_table = "terraform-state-${**NAME**}"
  }
}

provider "aws" {
  profile = "sensnet-${terraform.workspace}"
  region  = "${local.workspace["region"]}"
}

provider "aws" {
  profile = "sensnet-${terraform.workspace}"
  region  = "us-east-1"
  alias   = "edge"
}

data "aws_acm_certificate" "main" {
  provider = "aws.edge"
  domain   = "${local.workspace["domain"]}"

  statuses = [
    "ISSUED",
  ]
}

module "waf" {
  source        = "git@github.com:tesera/terraform-modules//waf-edge-owasp?ref=v0.2.10"
  name          = "${local.workspace["name"]}"
  defaultAction = "ALLOW"
}

output "web_acl_id" {
  value = "${module.waf.id}"
}

module "app" {
  source = "git@github.com:tesera/terraform-modules//public-static-assets?ref=v0.2.10"
  name   = "${local.workspace["name"]}"

  aliases = [
    "${local.workspace["domain"]}",
  ]

  acm_certificate_arn    = "${data.aws_acm_certificate.main.arn}"
  web_acl_id             = "${module.waf.id}"
  lambda_viewer_response = "${file("${path.module}/lambda-viewer-response.js")}"
}
