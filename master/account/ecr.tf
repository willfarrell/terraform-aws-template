
module "ecr_app" {
  source = "git@github.com:willfarrell/terraform-ec-modules//ecr?ref=v0.0.1"
  name   = "${local.workspace["name"]}-app"
}

output "ecr_app_url" {
  value = module.ecr_app.url
}
