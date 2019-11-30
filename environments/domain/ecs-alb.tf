# Cert
data "aws_acm_certificate" "alb" {
  domain = local.workspace["domain"]

  statuses = [
    "ISSUED",
  ]
}

# WAF
module "waf" {
  source        = "git@github.com:willfarrell/terraform-waf-module?ref=v0.0.1"
  type          = "regional"
  name          = local.workspace["name"]
  defaultAction = "ALLOW"
}

# ALB
module "alb" {
  source = "git@github.com:willfarrell/terraform-lb-module?ref=v0.0.1"
  name   = local.workspace["name"]
  type   = "application"
  vpc_id = module.vpc.id

  private_subnet_ids = module.vpc.private_subnet_ids

  waf_acl_id      = module.waf.id
  https_only      = true
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.alb.arn

  # ecs
  ports                  = [3000]
  autoscaling_group_name = module.ecs_alb.autoscaling_group_name
  security_group_id      = module.ecs_alb.security_group_id

  logging_bucket = "${local.workspace["name"]}-${local.workspace["env"]}-${local.workspace["region"]}-logs"
}

output "alb_endpoint" {
  value = module.alb.endpoint
}

# ECS - For long running process that need to be reached from the public
module "ecs_alb" {
  source         = "git@github.com:willfarrell/terraform-ec-modules//ecs?ref=v0.0.1"
  name           = "${local.workspace["name"]}-alb"
  ami_account_id = data.terraform_remote_state.master.outputs.account_id
  vpc_id         = module.vpc.id

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

  assume_role_arn = matchkeys(data.terraform_remote_state.master.outputs.ecr_role_arns, keys(data.terraform_remote_state.master.outputs.sub_accounts), list(local.workspace["env"]))[0]
}

output "ecs_alb_billing_suggestion" {
  value = module.ecs_alb.billing_suggestion
}

# EFS
module "efs_alb" {
  source = "git@github.com:willfarrell/terraform-ec-modules//efs?ref=v0.0.1"
  name   = "${local.workspace["name"]}-ecs-alb"

  subnet_ids = module.vpc.private_subnet_ids
}

# You can use `willfarrell/hello-world` to test out the ALB

# API Service
# Ref: https://github.com/terraform-providers/terraform-provider-aws/issues/632

resource "aws_ecs_task_definition" "api" {
  family = "${local.workspace["name"]}-ecs-${local.workspace["ecs_api_name"]}-task"
  requires_compatibilities = [
    "EC2",
  ]
  cpu                = "256"
  memory             = "256"
  network_mode       = "bridge"
  task_role_arn      = aws_iam_role.api_task.arn
  execution_role_arn = module.ecs_alb.iam_execution_role_arn
  # "image": "${data.terraform_remote_state.master.outputs.ecr_api_url}:${local.workspace["ecs_api_version"]}",
  container_definitions = <<DEFINITION
[
  {
    "name": "emr",
    "image": "willfarrell/hello-world:latest",
    "cpu": 256,
    "memory": 256,
    "essential":true,
    "portMappings":[{
      "hostPort":80,
      "containerPort":80,
      "protocol":"tcp"
    }],
    "environment":[
      { "name":"PORT", "value":"80" }
    ],
    "logConfiguration":{
      "logDriver": "awslogs",
      "options":{
        "awslogs-group":"${aws_cloudwatch_log_group.api.name}",
        "awslogs-region":"${local.workspace["region"]}",
        "awslogs-stream-prefix":"ecs"
      }
    },
    "mountPoints":[],
    "volumesFrom":[]
  }
]
DEFINITION

  lifecycle {
    ignore_changes = [
      #requires_compatibilities,
      #cpu,
      #memory,
      #container_definitions,
    ]
  }

  #tags {}
}

resource "aws_cloudwatch_log_group" "api" {
  name = "/ecs/${local.workspace["ecs_api_name"]}"
  retention_in_days = 30
  tags = {
    Name = "${local.workspace["name"]}-ecs-${local.workspace["ecs_api_name"]}"
  }
}

resource "aws_iam_role" "api_task" {
  name = "${local.workspace["name"]}-ecs-${local.workspace["ecs_emr_name"]}-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ecs-tasks.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "api_task" {
  name   = "${local.workspace["name"]}-ecs-${local.workspace["ecs_emr_name"]}-policy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "api" {
  role = aws_iam_role.api_task.name
  policy_arn = aws_iam_policy.api_task.arn
}

resource "aws_ecs_service" "api" {
  name = local.workspace["ecs_api_name"]
  cluster = module.ecs_alb.arn
  #launch_type     = ""
  task_definition = aws_ecs_task_definition.api.arn

  desired_count = 2
  ordered_placement_strategy {
    type = "spread"
    field = "attribute:ecs.availability-zone"
  }
  ordered_placement_strategy {
    type = "spread"
    field = "instanceId"
  }
  placement_constraints {
    type = "distinctInstance"
  }

  dynamic "load_balancer" {
    for_each = module.alb.target_group_arns
    content {
      target_group_arn = load_balancer.value
      container_name = local.workspace["ecs_api_name"]
      container_port = 80
    }
  }

  lifecycle {
    ignore_changes = [
      #task_definition
    ]
  }
}
