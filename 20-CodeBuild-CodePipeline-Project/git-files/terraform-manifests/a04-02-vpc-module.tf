module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name    = "${local.name}-${var.vpc_name}" 
  cidr    = var.vpc_cidr

  azs                                = var.vpc_azs
  private_subnets                    = var.private_subnets
  public_subnets                     = var.public_subnets
  
  # Database Subnets
  database_subnets                   = var.database_subnets
  create_database_subnet_group       = var.create_database_subnet_group
  create_database_subnet_route_table = var.create_database_subnet_route_table

  # VPC DNS Parameters (we can variablise these too)
  enable_dns_hostnames               = true
  enable_dns_support                 = true

  # NAT Gateways - Outbound Communication (Single NAT in the VPC)
  enable_nat_gateway                 = var.enable_nat_gateway
  single_nat_gateway                 = var.single_nat_gateway
  one_nat_gateway_per_az             = var.one_nat_gateway_per_az

  tags      = local.common_tags
  vpc_tags  = local.common_tags

  public_subnet_tags   = {
    type    = "public-subnet"
  }

  private_subnet_tags  = {
    type    = "private-subnet"
  }

  database_subnet_tags =  {
    type    = "database-subnet"
  }
}
