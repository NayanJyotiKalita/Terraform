module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name          = "private-security-group"
  description   = "Security Group with HTTP & SSH port open for the VPC i.e the internal traffic, egress ports are all world open"
  vpc_id        = module.vpc.vpc_id 

  # Ingress Rules & CIDR Blocks for ssh and http for internal traffic
  ingress_rules            = ["ssh-tcp", "http-80-tcp", "http-8080-tcp"]
  ingress_cidr_blocks      = [module.vpc.vpc_cidr_block]

  # Egress Rule - all-all open
  egress_rules             = ["all-all"]

  tags = local.common_tags
}

