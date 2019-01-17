locals {
  env = {
    default = {
      env    = "${terraform.workspace}"
      name   = "${**NAME**}"
      region = "us-west-2"

      # Cache
      cache_instance_type  = "cache.t2.micro"
      cache_engine         = "redis"
      cache_engine_version = "4.0"
      cache_read_replicas  = 0

      # Elastic
      elastic_instance_type  = "r4.large.elasticsearch"
      elastic_engine_version = "6.3"
      elastic_bootstrap_file = "${path.module}/elasticsearch/mappings.json"

      # RDS
      rds_instance_type    = "db.t2.micro"
      rds_replica_count    = 0
      rds_db_name          = "onguard"
      rds_bootstrap_folder = "${path.module}/mysql"
      rds_engine_version   = "5.7"

      ## cluster
      rds_engine_mode = "provisioned"
    }

    production = {
      multi_az                    = true
      apply_immediately           = false
      cache_type                  = "cluster"
      cache_node_count            = 2
      cache_replica_count         = 2
      elastic_node_count          = 2
      rds_type                    = "cluster"
      rds_engine                  = "aurora-mysql"
      rds_node_count              = 2
      rds_replica_count           = 2
      rds_allocated_storage       = 256
      rds_backup_retention_period = 90
    }

    staging = {
      multi_az                    = true
      apply_immediately           = false
      cache_type                  = "cluster"
      cache_node_count            = 2
      cache_replica_count         = 1
      elastic_node_count          = 2
      rds_type                    = "cluster"
      rds_engine                  = "aurora-mysql"
      rds_node_count              = 2
      rds_replica_count           = 1
      rds_allocated_storage       = 64
      rds_backup_retention_period = 30
    }

    testing = {
      multi_az                    = false
      apply_immediately           = true
      cache_type                  = "service"
      cache_node_count            = 1
      cache_replica_count         = 0
      elastic_node_count          = 1
      rds_type                    = "service"
      rds_engine                  = "mysql"
      rds_node_count              = 1
      rds_replica_count           = 0
      rds_allocated_storage       = 32
      rds_backup_retention_period = 7
    }

    development = {
      multi_az                    = false
      apply_immediately           = true
      cache_type                  = "service"
      cache_node_count            = 1
      cache_replica_count         = 0
      elastic_node_count          = 1
      rds_type                    = "service"
      rds_engine                  = "mysql"
      rds_node_count              = 1
      rds_replica_count           = 0
      rds_allocated_storage       = 8
      rds_backup_retention_period = 1
    }
  }

  workspace = "${merge(local.env["default"], local.env[terraform.workspace])}"
}
