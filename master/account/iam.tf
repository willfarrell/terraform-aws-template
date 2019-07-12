module "groups" {
  source       = "git@github.com:willfarrell/terraform-account-modules//groups?ref=v0.0.1"
  type         = "master"
  sub_accounts = local.workspace["sub_accounts"]
  providers    = {
    aws = aws.edge
  }
}

module "roles" {
  source         = "git@github.com:willfarrell/terraform-account-modules//roles?ref=v0.0.1"
  type           = "master"
  sub_accounts   = local.workspace["sub_accounts"]
  enable_ecr     = true
  enable_bastion = true
  providers      = {
    aws = aws.edge
  }
}

output "groups" {
  value = module.groups.list
}

output "role_arns" {
  value = module.roles.arns
}
