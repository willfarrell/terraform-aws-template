module "elasticsearch" {
  source = "git@github.com:tesera/terraform-modules//elasticsearch?ref=v0.2.9"
  name   = "${local.workspace["name"]}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  private_subnet_ids = [
    "${data.terraform_remote_state.vpc.private_subnet_ids}",
  ]

  #type                = "${local.workspace["elasticsearch_type"]}"           # N/A
  instance_type = "${local.workspace["elasticsearch_instance_type"]}"
  node_count    = "${local.workspace["relasticsearch_node_count"]}"

  #engine              = "${local.workspace["elasticsearch_engine"]}"          # N/A
  engine_version = "${local.workspace["elasticsearch_engine_version"]}"

  # bootstrap
  ssh_username      = "iam.username"
  ssh_identity_file = "~/.ssh/id_rsa"
  bastion_ip        = "${data.terraform_remote_state.vpc.bastion_ip}"

  #bootstrap_file      = "${local.workspace["elasticsearch_bootstrap_file"]}"
  security_group_ids = [
    "${data.terraform_remote_state.vpc.bastion_security_group_id}",
  ]
}

resource "aws_ssm_parameter" "elasticsearch_endpoint" {
  name        = "/elasticsearch/endpoint"
  description = "ElasticSearch Endpoint"
  type        = "SecureString"
  value       = "${module.elasticsearch.endpoint}"
}

output "elasticsearch_endpoint" {
  value = "${module.elasticsearch.endpoint}"
}

output "elasticsearch_security_group_id" {
  value = "${module.elasticsearch.security_group_id}"
}
