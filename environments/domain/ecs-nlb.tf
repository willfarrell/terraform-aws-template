
# NLB (optional)
//module "nlb" {
//  source = "../../modules/nlb"
//  name   = local.workspace["name"]
//  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
//
//  private_subnet_ids = [
//    "${data.terraform_remote_state.vpc.private_subnet_ids}",
//  ]
//
//  waf_acl_id      = "${module.waf.id}"
//  https_only      = false
//  ssl_policy      = "ELBSecurityPolicy-2016-08"
//  certificate_arn = "${data.aws_acm_certificate.main.arn}"
//
//  # ecs
//  port                   = 3000
//  autoscaling_group_name = "${module.ecs_private.autoscaling_group_id}"
//  security_group_id      = "${module.ecs_private.security_group_id}"
//}
//
//output "nlb_endpoint" {
//  value = "${module.nlb.endpoint}"
//}
//
//output "nlb_target_group_arn" {
//  value = "${module.nlb.target_group_arn}"
//}

# ECS - For long running and batch processes
module "ecs_nlb" {
  source = "git@github.com:willfarrell/terraform-ec-modules//ecs?ref=v0.0.1"
  name   = "${local.workspace["name"]}-nlb"
  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  instance_type    = local.workspace["instance_type"]
  min_size         = local.workspace["min_size"]
  max_size         = local.workspace["max_size"]
  desired_capacity = local.workspace["desired_capacity"]

  # Will need to comment out `efs` on initial apply TODO BUG
  efs_ids = [
    module.efs_private.efs_id
  ]

  efs_security_group_ids = [
    module.efs_private.security_group_id
  ]
}

output "ecs_nlb_billing_suggestion" {
  value = module.ecs_nlb.billing_suggestion
}

# EFS
module "efs_private" {
  source = "git@github.com:willfarrell/terraform-ec-modules//efs?ref=v0.0.1"
  name   = "${local.workspace["name"]}-ecs-nlb"

  subnet_ids = module.vpc.private_subnet_ids
}

# TODO sg - allow proxy access from bastion to private ports

