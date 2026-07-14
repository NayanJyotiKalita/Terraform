resource "aws_launch_template" "my_base_launch_template" {

  name_prefix            = "${local.name}-"
  description            = "My Base Lauch Template"
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [module.private_sg.id]
  user_data              = filebase64("${path.module}/app-install.sh")
  update_default_version = true 
  ebs_optimized          = true    

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 10
      delete_on_termination = true
      volume_type = "gp3"
    }
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = local.name
    }
  }
}