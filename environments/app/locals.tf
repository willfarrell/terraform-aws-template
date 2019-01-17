locals {
  env = {
    default = {
      env    = "${terraform.workspace}"
      name   = "${**NAME**}"
      region = "us-west-2"
    }

    production = {
      domain = "app.example.com"
    }

    staging = {
      domain = "uat-app.example.com"
    }

    testing = {
      domain = "qa-app.example.com"
    }

    development = {
      domain = "dev-app.example.com"
    }
  }

  workspace = "${merge(local.env["default"], local.env[terraform.workspace])}"
}

output "workspace" {
  value = "${terraform.workspace}"
}
