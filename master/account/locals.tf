locals {
  env = {
    default = {
      env     = terraform.workspace
      profile = "{**PROFILE**}"
      name    = "{**NAME**}"
      region  = "us-east-1"

      sub_accounts = {
        production  = "000000000000"
        staging     = "000000000000"
        testing     = "000000000000"
        development = "000000000000"
      }
    }
  }

  workspace = merge(local.env["default"], local.env[terraform.workspace])
}

output "workspace" {
  value = terraform.workspace
}
