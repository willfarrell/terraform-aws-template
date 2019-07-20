
module "amis" {
  source       = "git@github.com:willfarrell/terraform-ec-modules//ami?ref=v0.0.1"
  sub_accounts = data.terraform_remote_state.master.outputs.sub_accounts
  images = [
    "amzn2-ami-hvm-*-x86_64-bastion",
    "amzn2-ami-hvm-*-x86_64-ecs",
    "amzn-ami-hvm-*-x86_64-nat"
  ]
}
