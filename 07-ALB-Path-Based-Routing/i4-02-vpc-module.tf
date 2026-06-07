module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name             = "${local.name}-${var.vpc_name}"
  cidr             = var.vpc_cidr_block
  azs              = var.vpc_azs
  public_subnets   = var.vpc_public_subnets
  private_subnets  = var.vpc_private_subnets

  # Database Subnets
  database_subnets                    = var.vpc_database_subnets
  create_database_subnet_group        = var.vpc_create_database_subnet_group
  create_database_subnet_route_table  = var.vpc_create_database_subnet_route_table
  # This usage of variables replaces the use of writing the hardcoded values for each identifier
  # e.g. : create_database_internet_gateway_route = true
         # create_database_nat_gateway_route = true

  # NAT Gateways - Outbound Communication (Single NAT in the VPC)
  enable_nat_gateway     = var.vpc_enable_nat_gateway
  single_nat_gateway     = var.vpc_single_nat_gateway
  one_nat_gateway_per_az = var.vpc_one_nat_gateway_per_az

  # VPC DNS Parameters (we can variablise these too)
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
  vpc_tags = local.common_tags

  public_subnet_tags = {
    type = "public-subnets"
  }
  
  private_subnet_tags = {
    type = "private-subnets"
  }

  database_subnet_tags = {
    type = "database-subnets"
  }
}