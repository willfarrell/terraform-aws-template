data "aws_acm_certificate" "main" {
  provider = "aws.edge"
  domain   = local.workspace["app_domain"]

  statuses = [
    "ISSUED",
  ]

  providers = {
    aws = "aws.edge"
  }
}

module "app" {
  source = "git@github.com:willfarrell/terraform-public-static-assets-module?ref=v0.2.1"
  name   = local.workspace["name"]

  aliases = [
    local.workspace["app_domain"],
  ]

  acm_certificate_arn = data.aws_acm_certificate.main.arn
  web_acl_id          = module.waf.id
  lambda = {
    "viewer-response" = file("${path.module}/cloudfront-lambda-viewer-response.js")
  }
  logging_bucket = "${local.workspace["name"]}-${local.workspace["env"]}-edge-logs"
  providers = {
    aws = "aws.edge"
  }
}

module "waf" {
  source         = "git@github.com:willfarrell/terraform-waf-module?ref=v0.0.1"
  type           = "edge"
  name           = local.workspace["name"]
  defaultAction  = "ALLOW"
  logging_bucket = "${local.workspace["name"]}-${local.workspace["env"]}-edge-logs"
  providers = {
    aws = "aws.edge"
  }
}

output "waf_bad-bot_ipset_id" {
  value = module.waf.ipset_bad-bot_id
}
