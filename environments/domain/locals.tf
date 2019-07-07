locals {
  env = {
    default = {
      env     = "${terraform.workspace}"
      profile = "${**PROFILE**}"
      name    = "${**NAME**}"
      region  = "ca-central-1"

      # Database
      ## Cache
      redis_instance_type  = "cache.t2.micro"
      redis_engine         = "redis"
      redis_engine_version = "5.0"

      ## ElasticSearch
      elasticsearch_instance_type  = "r4.large.elasticsearch"
      elasticsearch_engine         = "elasticsearch"
      elasticsearch_engine_version = "6.5"
      elasticsearch_bootstrap_file = "${path.module}/elasticsearch/mappings.json"

      ## RDS
      mysql_instance_type    = "db.t2.micro"
      mysql_replica_count    = 0
      mysql_db_name          = "${**NAME**}"
      mysql_bootstrap_folder = "${path.module}/mysql"
      mysql_engine_version   = "8.0"
      mysql_engine_mode      = "provisioned"

      postgres_instance_type    = "db.t2.micro"
      postgres_replica_count    = 0
      postgres_db_name          = "${**NAME**}"
      postgres_bootstrap_folder = "${path.module}/postgres"
      postgres_engine_version   = "11"
      postgres_engine_mode      = "provisioned"
    }

    production = {
      # CloudFront
      app_domain = "app.example.com"

      # API
      instance_type    = "t2.micro"
      min_size         = 2
      max_size         = 5
      desired_capacity = 3
      api_domain       = "api.example.com"

      api_version = "v2.0.0"

      # VPC
      cidr_block            = "10.*.0.0/16"
      az_count              = "3"
      nat_type              = "gateway"
      bastion_instance_type = "t2.micro"
      bastion_user_group    = "User"
      bastion_sudo_group    = "ProductionAdmin"

      # Database
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
      # CloudFront
      app_domain = "uat-app.example.com"

      # API
      instance_type    = "t2.micro"
      min_size         = 2
      max_size         = 3
      desired_capacity = 2
      api_domain       = "uat-api.example.com"

      api_version = "v2.0.0"

      # VPC
      cidr_block            = "10.*.0.0/16"
      az_count              = "2"
      nat_type              = "gateway"
      bastion_instance_type = "t2.micro"
      bastion_user_group    = "User"
      bastion_sudo_group    = "StagingAdmin"

      # Database
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
      # CloudFront
      app_domain = "qa-app.example.com"

      # API
      instance_type    = "t2.micro"
      min_size         = 1
      max_size         = 1
      desired_capacity = 1
      api_domain       = "qa-api.example.com"

      # VPC
      cidr_block            = "10.*.0.0/16"
      az_count              = "2"
      nat_type              = "instance"
      bastion_instance_type = "t2.micro"
      bastion_user_group    = "User"
      bastion_sudo_group    = "TestingAdmin"

      # Database
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
      # CloudFront
      app_domain = "dev-app.example.com"

      # API
      instance_type    = "t2.micro"
      min_size         = 1
      max_size         = 1
      desired_capacity = 1
      api_domain       = "dev-api.example.com"

      # VPC
      cidr_block            = "10.8.0.0/16"
      az_count              = "2"
      nat_type              = "instance"
      bastion_instance_type = "t2.micro"
      bastion_user_group    = "User"
      bastion_sudo_group    = "DevelopmentAdmin"

      # Database
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
