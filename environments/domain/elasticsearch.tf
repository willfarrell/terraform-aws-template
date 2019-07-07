module "elasticsearch" {
  source = "git@github.com:willfarrell/terraform-db-modules//elasticsearch?ref=v0.2.9"
  name   = local.workspace["name"]
  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  #type                = local.workspace["elasticsearch_type"]          # N/A
  instance_type = local.workspace["elasticsearch_instance_type"]
  node_count    = local.workspace["relasticsearch_node_count"]

  #engine              = local.workspace["elasticsearch_engine"]          # N/A
  engine_version = local.workspace["elasticsearch_engine_version"]

  # bootstrap
  ssh_username      = "iam.username"
  ssh_identity_file = "~/.ssh/id_rsa"
  bastion_ip        = module.vpc.bastion_ip

  #bootstrap_file      = local.workspace["elasticsearch_bootstrap_file"]
  security_group_ids = [
    module.vpc.bastion_security_group_id
  ]
}

resource "aws_ssm_parameter" "elasticsearch_endpoint" {
  name        = "/database/elasticsearch/endpoint"
  description = "ElasticSearch Endpoint"
  type        = "SecureString"
  value       = module.elasticsearch.endpoint
}

output "elasticsearch_endpoint" {
  value = module.elasticsearch.endpoint
}
