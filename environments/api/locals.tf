locals {
  env = {
    default = {
      env    = "${terraform.workspace}"
      name   = "${**NAME**}"
      region = "us-west-2"
    }

    production = {
      instance_type    = "t2.micro"
      min_size         = 2
      max_size         = 5
      desired_capacity = 3
      domain           = "api.example.com"

      api_version = "v2.0.0"
    }

    staging = {
      instance_type    = "t2.micro"
      min_size         = 2
      max_size         = 3
      desired_capacity = 2
      domain           = "uat-api.example.com"

      api_version = "v2.0.0"
    }

    testing = {
      instance_type    = "t2.micro"
      min_size         = 1
      max_size         = 1
      desired_capacity = 1
      domain           = "qa-api.example.com"
    }

    development = {
      instance_type    = "t2.micro"
      min_size         = 1
      max_size         = 1
      desired_capacity = 1
      domain           = "dev-api.example.com"
    }
  }

  workspace = "${merge(local.env["default"], local.env[terraform.workspace])}"
}

output "workspace" {
  value = "${terraform.workspace}"
}
