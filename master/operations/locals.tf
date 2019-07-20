locals {
  env = {
    default = {
      env     = terraform.workspace
      profile = "{**PROFILE**}"
      name    = "{**NAME**}"
      region  = "ca-central-1"
    }
  }

  workspace = merge(local.env["default"], local.env[terraform.workspace])
}

output "workspace" {
  value = terraform.workspace
}
