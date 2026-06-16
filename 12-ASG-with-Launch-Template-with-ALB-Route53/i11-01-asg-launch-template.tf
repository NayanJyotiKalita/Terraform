resource "aws_launch_template" "my_launch_template" {
  name = "my-basic-launch-template"
  description = "My Basic Launch Template"
  image_id = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = var.keypair

  # We attach the private sg to the launch template as we do not have any private instance, the private instances will be created by the launch template along with the ASG
  vpc_security_group_ids = [module.private_sg.security_group_id] 
  user_data = filebase64("${path.module}/app-install.sh")  # all the instances created using this template will have this script running in them
  ebs_optimized = true

  # default_version = 1  
  update_default_version = true  # if we use the default_version, it could conflict with this argument 
  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 10
      delete_on_termination = true 
      encrypted = true 
      volume_type = "gp3"
    }
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "myasg"
    }
  }

}

