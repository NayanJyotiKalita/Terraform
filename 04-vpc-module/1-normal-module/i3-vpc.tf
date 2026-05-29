# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"  # best to use the lastest one with the "=" sign, not "~>" or ">"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]

  # Database Subnets
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true

  # create_database_nat_gateway_route = true  # Use when needed
  # create_database_internet_gateway_route = false   # Never use it in production

  # NAT Gateways - Outbound Communication (One NAT per AZ)
  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    type = "public-subnets"
  }

  private_subnet_tags = {
    type = "private-subnets"
  }

  database_subnet_tags = {
    type = "database-subnets"
  }

  tags = {
    owner = "haskell"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "dev-vpc"
  }
}





