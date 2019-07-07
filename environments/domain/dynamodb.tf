# VPC
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id          = module.vpc.id
  service_name    = "com.amazonaws.${local.workspace["region"]}.dynamodb"
  route_table_ids = module.vpc.private_route_table_ids

  policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY
}

# Database
