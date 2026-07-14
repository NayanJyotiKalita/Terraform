module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  name        = "${local.name}-alb-sg"
  description = "Security Group with HTTP & SSH port open for the VPC i.e the internal traffic, egress ports are all world open"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    https-from-outside = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTPS from the outside world"
    }

    http-from-vpc = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTP from the outside world"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "All outbound"
    }
  }
  tags = local.common_tags
  
}