locals {
  env = {
    default = {
      env    = "${terraform.workspace}"
      name   = "${**NAME**}"
      region = "us-west-2"

      # Cache
      redis_instance_type  = "cache.t2.micro"
      redis_engine         = "redis"
      redis_engine_version = "4.0"

      # ElasticSearch
      elasticsearch_instance_type  = "r4.large.elasticsearch"
      elasticsearch_engine         = "elasticsearch"
      elasticsearch_engine_version = "6.3"
      elasticsearch_bootstrap_file = "${path.module}/elasticsearch/mappings.json"

      # RDS
      mysql_instance_type    = "db.t2.micro"
      mysql_replica_count    = 0
      mysql_db_name          = "{**NAME**}"
      mysql_bootstrap_folder = "${path.module}/mysql"
      mysql_engine_version   = "5.7"
      mysql_engine_mode      = "provisioned"

      postgres_instance_type    = "db.t2.micro"
      postgres_replica_count    = 0
      postgres_db_name          = "{**NAME**}"
      postgres_bootstrap_folder = "${path.module}/postgres"
      postgres_engine_version   = "10"
      postgres_engine_mode      = "provisioned"
    }

    production = {
      multi_az          = true
      apply_immediately = false

      redis_type          = "cluster"
      redis_node_count    = 2
      redis_replica_count = 2

      elasticsearch_node_count = 2

      mysql_type                    = "cluster"
      mysql_engine                  = "aurora-mysql"
      mysql_node_count              = 2
      mysql_replica_count           = 2
      mysql_allocated_storage       = 256
      mysql_backup_retention_period = 90

      postgres_type                    = "cluster"
      postgres_engine                  = "aurora-postgres"
      postgres_node_count              = 2
      postgres_replica_count           = 2
      postgres_allocated_storage       = 256
      postgres_backup_retention_period = 90
    }

    staging = {
      multi_az          = true
      apply_immediately = false

      redis_type          = "cluster"
      redis_node_count    = 2
      redis_replica_count = 1

      elasticsearch_node_count = 2

      mysql_type                    = "cluster"
      mysql_engine                  = "aurora-mysql"
      mysql_node_count              = 2
      mysql_replica_count           = 1
      mysql_allocated_storage       = 64
      mysql_backup_retention_period = 30

      postgres_type                    = "cluster"
      postgres_engine                  = "aurora-postgres"
      postgres_node_count              = 2
      postgres_replica_count           = 1
      postgres_allocated_storage       = 64
      postgres_backup_retention_period = 30
    }

    testing = {
      multi_az          = false
      apply_immediately = true

      redis_type          = "service"
      redis_node_count    = 1
      redis_replica_count = 0

      elasticsearch_node_count = 1

      mysql_type                    = "service"
      mysql_engine                  = "mysql"
      mysql_node_count              = 1
      mysql_replica_count           = 0
      mysql_allocated_storage       = 32
      mysql_backup_retention_period = 7

      postgres_type                    = "service"
      postgres_engine                  = "postgres"
      postgres_node_count              = 1
      postgres_replica_count           = 0
      postgres_allocated_storage       = 32
      postgres_backup_retention_period = 7
    }

    development = {
      multi_az          = false
      apply_immediately = true

      redis_type          = "service"
      redis_node_count    = 1
      redis_replica_count = 0

      elasticsearch_node_count = 1

      mysql_type                    = "service"
      mysql_engine                  = "mysql"
      mysql_node_count              = 1
      mysql_replica_count           = 0
      mysql_allocated_storage       = 8
      mysql_backup_retention_period = 1

      postgres_type                    = "service"
      postgres_engine                  = "postgres"
      postgres_node_count              = 1
      postgres_replica_count           = 0
      postgres_allocated_storage       = 8
      postgres_backup_retention_period = 1
    }
  }

  workspace = "${merge(local.env["default"], local.env[terraform.workspace])}"
}
