module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name          = "alb-security-group"
  description   = "Security Group with HTTP open for entire Internet"
  vpc_id        = module.vpc.vpc_id 

  # Ingress Rules & CIDR Blocks for ssh and http for internal traffic
  ingress_rules            = ["http-80-tcp"]
  ingress_cidr_blocks      = ["0.0.0.0/0"]

  # Egress Rule - all-all open
  egress_rules             = ["all-all"]
  tags = local.common_tags

  ingress_with_cidr_blocks = [
    {
      from_port   = 81
      to_port     = 81
      protocol    = 6
      description = "Allow Port 81 from internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

