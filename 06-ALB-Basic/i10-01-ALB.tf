module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.0"

  name    = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = [module.loadbalancer_sg.security_group_id]

  # For example only
  enable_deletion_protection = false

  # Listeners
  listeners = {
    # Listener: my-http-listener
    my-http-listener = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "mytg"
      }
    } # End of my-http-listener

    # Listener: my-http-81-listener
    my-http-listener = {
      port     = 81
      protocol = "HTTP"
      forward = {
        target_group_key = "mytg"
      }
    } # End of my-http-81-listener

  }  # End of listeners block
  
  # Target Groups
  target_groups = {
    mytg = {
      # VERY IMPORTANT: We will create aws_lb_target_group_attachment resource separately when we use create_attachment = false
      create_attachment = false
      name_prefix                       = "mytg-"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      protocol_version = "HTTP1"

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      } # End of health_check Block
      tags = local.common_tags  # target_group tags
    } # End of taget_groups Block
  }
  tags = local.common_tags  # ALB Tags
}

resource "aws_lb_target_group_attachment" "mytg" {
  for_each = {for i, j in module.ec2_private: i => j}   # module.ec2_private redirects to the entire private ec2 details, i redirects to the indices (i.e. 0 and 1 in our case) and j redirects to the instance details
  target_group_arn = module.alb.target_groups["mytg"].arn
  target_id        = each.value.id
  port             = 80
}

## i = indices of ec2_instance e.g - 0 and 1
## j = ec2_instance_details

# Output block to visualize the i and j
output "i_j_private_outputs" {
  value = {for instance_idx, instance_details in module.ec2_private: instance_idx => instance_details}
}

