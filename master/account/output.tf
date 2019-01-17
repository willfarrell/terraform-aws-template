# Used by environments/account
output "account_id" {
  value = "${module.defaults.account_id}"
}

output "sub_accounts" {
  value = "${var.sub_accounts}"
}

output "groups" {
  value = "${module.groups.list}"
}

output "bastion_role_arns" {
  value = "${module.bastion_roles.arns}"
}
