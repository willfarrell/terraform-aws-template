
resource "aws_ecr_repository" "ecs" {
  name = local.workspace["name"]
}

output "ecs_repository_url" {
  value = aws_ecr_repository.ecs.repository_url
}

module "ecs" {
  source = "git@github.com:willfarrell/terraform-ec-modules//ecs?ref=v0.2.7"
  name   = local.workspace["name"]
  vpc_id = module.vpc.vpc_id

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
  source = "git@github.com:willfarrell/terraform-ec-modules//efs?ref=v0.2.4"
  name   = "${local.workspace["name"]}-ecs"

  subnet_ids = module.vpc.private_subnet_ids
}

# TODO sg - allow proxy access from bastion to private ports

