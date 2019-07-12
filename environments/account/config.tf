
# TODO add roles module

module "api-gateway" {
  #source = "git@github.com:willfarrell/terraform-account-modules//api-gateway?ref=v0.0.1"
  source = "../../../../../github/terraform-sub-account-modules/api-gateway"
  providers = {
    aws = aws.edge
  }
}

module "cloudtrail" {
  #source         = "git@github.com:willfarrell/terraform-account-modules//cloudtrail?ref=v0.0.1"
  source         = "../../../../../github/terraform-account-modules/cloudtrail"
  name           = local.workspace["name"]
  logging_bucket = module.edge-logs.id
  providers = {
    aws = aws.edge
  }
}

module "edge-logs" {
  #source = "git@github.com:willfarrell/terraform-logs-module?ref=v0.5.2"
  source         = "../../../../../github/terraform-logs-module"
  name   = "${local.workspace["name"]}-${local.workspace["env"]}-edge"
  providers = {
    aws = aws.edge
  }
  tags = {
    Name = "Edge Logs"
  }
}

# Primary Region

module "region-logs" {
  #source = "git@github.com:willfarrell/terraform-logs-module?ref=v0.5.2"
  source         = "../../../../../github/terraform-logs-module"
  name   = "${local.workspace["name"]}-${local.workspace["env"]}-${local.workspace["region"]}"
  tags = {
    Name = "${local.workspace["region"]} Logs"
  }
}


