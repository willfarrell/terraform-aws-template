module "roles" {
  source            = "git@github.com:willfarrell/terraform-account-modules//roles?ref=v0.0.1"
  type              = "member"
  master_account_id = data.terraform_remote_state.master.outputs.account_id
  providers = {
    aws = aws.edge
  }
}

output "role_arns" {
  value = module.roles.arns
}
