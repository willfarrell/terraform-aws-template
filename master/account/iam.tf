
# May need to comment out until after module.organization.sub_accounts exists
module "groups" {
  source       = "git@github.com:willfarrell/terraform-account-modules//groups?ref=v0.0.5"
  type         = "master"
  sub_accounts = module.organization.sub_accounts
  providers = {
    aws = aws.edge
  }
}

module "roles" {
  source         = "git@github.com:willfarrell/terraform-account-modules//roles?ref=v0.0.5"
  type           = "master"
  sub_accounts   = module.organization.sub_accounts
  enable_ecr     = true
  enable_bastion = true
  providers = {
    aws = aws.edge
  }
}

output "groups" {
  value = module.groups.list
}

output "role_arns" {
  value = module.roles.arns
}

output "bastion_role_arns" {
  value = module.roles.bastion_arns
}
