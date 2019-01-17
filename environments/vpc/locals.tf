locals {
  env = {
    default = {
      env    = "${terraform.workspace}"
      name   = "${**NAME**}"
      region = "us-west-2"
    }

    production = {
      cidr_block            = "10.*.0.0/16"
      az_count              = "3"
      nat_type              = "gateway"
      bastion_instance_type = "t2.micro"
      bastion_user_group    = "User"
      bastion_sudo_group    = "ProductionAdmin"
    }

    staging = {
      cidr_block            = "10.*.0.0/16"
      az_count              = "2"
      nat_type              = "gateway"
      bastion_instance_type = "t2.micro"
      bastion_user_group    = "User"
      bastion_sudo_group    = "StagingAdmin"
    }

    testing = {
      cidr_block            = "10.*.0.0/16"
      az_count              = "2"
      nat_type              = "instance"
      bastion_instance_type = "t2.micro"
      bastion_user_group    = "User"
      bastion_sudo_group    = "TestingAdmin"
    }

    development = {
      cidr_block            = "10.8.0.0/16"
      az_count              = "2"
      nat_type              = "instance"
      bastion_instance_type = "t2.micro"
      bastion_user_group    = "User"
      bastion_sudo_group    = "DevelopmentAdmin"
    }
  }

  workspace = "${merge(local.env["default"], local.env[terraform.workspace])}"
}

output "workspace" {
  value = "${terraform.workspace}"
}
