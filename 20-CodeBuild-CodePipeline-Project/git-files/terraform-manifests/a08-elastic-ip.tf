resource "aws_eip" "bastion_eip" {
  depends_on = [ module.public_bastion_sg, module.vpc ]
  instance = module.ec2_bastion.id
  domain   = "vpc"
  tags = local.common_tags
}