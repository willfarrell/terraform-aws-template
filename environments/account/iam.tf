
module "roles" {
  source       = "git@github.com:willfarrell/terraform-account-modules//roles?ref=v0.0.1"
  type         = "sub"
  master_account_id = data.terraform_remote_state.master.id
  providers = {
    aws = aws.edge
  }
}


output "role_arns" {
  value = module.roles.arns
}
