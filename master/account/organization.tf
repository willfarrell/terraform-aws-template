module "organization" {
  source        = "git@github.com:willfarrell/terraform-account-modules//organization?ref=v0.0.2"
  account_email = local.workspace["account_email"]
  sub_accounts  = local.workspace["sub_accounts"]
}

output "sub_accounts" {
  value = module.organization.sub_accounts
}
