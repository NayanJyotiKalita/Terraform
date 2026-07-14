resource "aws_autoscaling_group" "my_asg" {
  name_prefix               = "${local.name}-"
  max_size                  = 6
  min_size                  = 2
  desired_capacity          = 2

  health_check_grace_period = 300
  health_check_type         = "EC2"

  force_delete              = true
  vpc_zone_identifier       = [module.vpc.private_subnets]

  target_group_arns = [ module.alb.target_groups["tg"].arn ]

  launch_template {
    id      =  aws_launch_template.my_base_launch_template.id
    version =  aws_launch_template.my_base_launch_template.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["desired_capacity"] # We can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger 
  }

  tag {
    key                 = "Owner"
    value               = "DevOps-Team"
    propagate_at_launch = true  
  }
}