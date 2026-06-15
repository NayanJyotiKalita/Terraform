# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_private" {
  depends_on = [ module.vpc ]
  source     = "terraform-aws-modules/ec2-instance/aws"
  version    = "6.4.0"

  name                   = "${var.environment}-private"
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.keypair 
  user_data              = file("${path.module}/app-install.sh")
  tags                   = local.common_tags
  vpc_security_group_ids = [module.private_sg.security_group_id]

  # instance_count is deprecated
  # instance_count         = var.private_instance_count
  # subnet_ids = [module.vpc.private_subnets[0],module.vpc.private_subnets[1] ]

  # We for_each now instead of instance_count
  for_each               = toset([for i in range(var.private_instance_count) : tostring(i)])
  subnet_id              = element(module.vpc.private_subnets, tonumber(each.key))
}


# ELEMENT Function
# terraform console 
# element(["viny", "dale", "kaka"], 0)
# element(["viny", "dale", "kaka"], 1)
# element(["viny", "dale", "kaka"], 2)