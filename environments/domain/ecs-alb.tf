

# Cert
data "aws_acm_certificate" "alb" {
  domain = local.workspace["domain"]

  statuses = [
    "ISSUED",
  ]
}

# WAF
module "waf" {
  source        = "git@github.com:willfarrell/terraform-waf-modules/?ref=v0.3.7"
  type          = "regional"
  name          = local.workspace["name"]
  defaultAction = "ALLOW"
}

# ALB
module "alb" {
  source = "git@github.com:willfarrell/terraform-lb-modules/?ref=v0.3.7"
  name   = local.workspace["name"]
  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  waf_acl_id      = module.waf.id
  https_only      = true
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.alb.arn

  # ecs
  port                   = 3000
  autoscaling_group_name = module.ecs_alb.autoscaling_group_name
  security_group_id      = module.ecs_alb.security_group_id
}

output "alb_endpoint" {
  value = module.alb.endpoint
}

# ECS - For long running process that need to be reached from the public
module "ecs_alb" {
  source = "git@github.com:willfarrell/terraform-ec-modules//ecs?ref=v0.2.7"
  name   = "${local.workspace["name"]}-alb"
  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  instance_type    = local.workspace["instance_type"]
  min_size         = local.workspace["min_size"]
  max_size         = local.workspace["max_size"]
  desired_capacity = local.workspace["desired_capacity"]

  # Will need to comment out `efs` on initial apply TODO BUG
  efs_ids = [
    module.efs_alb.efs_id
  ]

  efs_security_group_ids = [
    module.efs_alb.security_group_id
  ]
}

output "ecs_alb_billing_suggestion" {
  value = module.ecs_alb.billing_suggestion
}

# EFS
module "efs_alb" {
  source = "git@github.com:willfarrell/terraform-ec-modules//efs?ref=v0.3.7"
  name   = "${local.workspace["name"]}-ecs-alb"

  subnet_ids = module.vpc.private_subnet_ids
}

# TODO sg - allow proxy access from bastion to private ports
# TODO VPN


# TODO APIG

