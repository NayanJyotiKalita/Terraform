module "ec2_private_app2" {
  depends_on = [ module.vpc ]
  source     = "terraform-aws-modules/ec2-instance/aws"
  version    = "6.4.0"

  name                   = "${var.environment}-private-app2"
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.keypair
  #subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.private_sg.security_group_id]
  user_data              = file("${path.module}/app-install-2.sh")
  tags                   = local.common_tags

  for_each               = toset([for i in range(var.private_instance_count): tostring(i)])
  subnet_id              = element(module.vpc.private_subnets, tonumber(each.key))            
}

