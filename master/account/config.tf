

module "cloudtrail" {
  source         = "git@github.com:willfarrell/terraform-account-modules//cloudtrail?ref=v0.0.2"
  name           = local.workspace["name"]
  logging_bucket = module.edge-logs.id
  providers = {
    aws = aws.edge
  }
}

module "edge-logs" {
  source = "git@github.com:willfarrell/terraform-logs-module?ref=v0.5.3"
  name   = "${local.workspace["name"]}-${local.workspace["env"]}-edge"
  providers = {
    aws = aws.edge
  }
  tags = {
    Name = "Edge Logs"
  }
}
