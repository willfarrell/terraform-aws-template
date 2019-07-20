module "ecs" {
  source         = "git@github.com:willfarrell/terraform-ec-modules//ecs?ref=v0.0.3"
  name           = local.workspace["name"]
  ami_account_id = data.terraform_remote_state.master.outputs.account_id
  vpc_id         = module.vpc.id

  private_subnet_ids = module.vpc.private_subnet_ids

  instance_type    = local.workspace["instance_type"]
  min_size         = local.workspace["min_size"]
  max_size         = local.workspace["max_size"]
  desired_capacity = local.workspace["desired_capacity"]

  # Will need to comment out `efs` on initial apply TODO BUG
  efs_ids = [
    module.efs.efs_id
  ]

  efs_security_group_ids = [
    module.efs.security_group_id
  ]
}

output "ecs_billing_suggestion" {
  value = module.ecs.billing_suggestion
}

# EFS
module "efs" {
  source = "git@github.com:willfarrell/terraform-ec-modules//efs?ref=v0.0.3"
  name   = "${local.workspace["name"]}-ecs"

  subnet_ids = module.vpc.private_subnet_ids
}

# TODO sg - allow proxy access from bastion to private ports

# TODO task def
