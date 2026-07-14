module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  name        = "${local.name}-private-sg"
  description = "Security Group with HTTP & SSH port open for the VPC i.e the internal traffic, egress ports are all world open"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    ssh-from-vpc = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = module.vpc.vpc_cidr_block
      description = "SSH from within the VPC"
    }

    http-from-vpc = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = module.vpc.vpc_cidr_block
      description = "HTTP from within the VPC"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
      description = "To VPC"
    }
  }
  tags = local.common_tags
  
}