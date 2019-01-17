# VPC
output "vpc_id" {
  value = "${module.vpc.id}"
}

## Public Subnet
output "public_subnet_ids" {
  value = "${module.vpc.public_subnet_ids}"
}

output "nat_ips" {
  value = "${module.vpc.public_ips}"
}

output "nat_billing_suggestion" {
  value = "${module.vpc.billing_suggestion}"
}

### Bastion

## Private Subnet
output "private_subnet_ids" {
  value = "${module.vpc.private_subnet_ids}"
}
