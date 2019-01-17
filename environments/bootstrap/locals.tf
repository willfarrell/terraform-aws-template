locals {
  env       = {
    default     = {
      env    = "${terraform.workspace}"
      name   = "${**NAME**}"
      region = "us-west-2"
    }

    production  = {

    }

    staging     = {

    }

    testing     = {

    }

    development = {

    }
  }

  workspace = "${merge(local.env["default"], local.env[terraform.workspace])}"
}
