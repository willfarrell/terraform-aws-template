locals {
  env = {
    default = {
      env     = terraform.workspace
      profile = "{**PROFILE**}"
      name    = "{**NAME**}"
      region  = "us-east-1"

      account_email = "aws-root@example.com"

      sub_accounts = ["production","staging","testing","development"]
    }
  }

  workspace = merge(local.env["default"], local.env[terraform.workspace])
}

output "workspace" {
  value = terraform.workspace
}
