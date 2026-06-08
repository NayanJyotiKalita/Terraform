module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.0"

  name               = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.loadbalancer_sg.security_group_id]

  # For example only
  enable_deletion_protection = false

  # Listeners
  listeners = {
    # Listener-1: my-http-https-redirect
    my-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    } # End of my-http-https-redirect Block

    my-https-listener = {
      port                        = 443
      protocol                    = "HTTPS"
      ssl_policy                  = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn             = module.acm.acm_certificate_arn

      # Fixed Response for Root Context
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed Static message - for Root Context"
        status_code  = "200"
      }# End of Fixed Response

      # Load Balancer Rules
      rules = {
        # Rule-1: myapp1-rule - custom-header=my-app-1 should go to App1 EC2 Instances
        app1-rule = {
          priority = 1
          actions = [{
            weighted_forward = {
              target_groups = [
                {
                  target_group_key = "mytg1"
                  weight           = 1
                }
              ]
              stickiness = {
                enabled  = true
                duration = 3600
              }
            }
          }]
          conditions = [
            {
              host_header = {
                http_header_name = "custom-header"
                values = ["app-1", "app1", "my-app-1", "my-app1"]
              }
            }
          ]
        } # End of app1-rule

        # Rule-2: app2-rule - custom-header=my-app-2 should go to App2 EC2 Instances 
        app2-rule = {
          priority = 2
          actions = [{
            weighted_forward = {
              target_groups = [
                {
                  target_group_key = "mytg2"
                  weight           = 1
                }
              ]
              stickiness = {
                enabled  = true
                duration = 3600
              }
            }
          }]
          conditions = [
            {
              host_header = {
                http_header_name = "custom-header"
                values = ["app-2", "app2", "my-app-2", "my=app2"]
              }
            }
          ]
        } # End of app2-rule Block

        # Rule-3: Query String Redirect Redirect Rule
        redirect-query = {
          priority = 3
          actions = [{
            redirect = {
              status_code = "HTTP_302"
              host        = "www.youtube.com"
              path        = "/watch"
              query       = ""
              protocol    = "HTTPS"
            }
          }]

          conditions = [{
            query_string = [{
              key   = "website"
              value = "aws-learn"
            }]
          }]
        }# End of Rule-3 Query String Redirect Redirect Rule

        # Rule-4: Host Header Redirect
        redirect-host-header = {
          priority = 4
          actions = [{
            redirect = {
              status_code = "HTTP_302"
              host        = "www.youtube.com"
              path        = "/watch"
              query       = ""
              protocol    = "HTTPS"
            }
          }]

          conditions = [{
            host_header = {
              values = ["aws-skill.mycloudevops.com"]
            }
          }]
        }# End of Rule-4 Host Header Redirect
      } # End Rules Block
    } # End of my-https-listener Block
  } # # End Listeners Block
  

  # Target Groups
  target_groups = {
    # Target Group-1: mytg1
    mytg1 = {
      # VERY IMPORTANT: We will create aws_lb_target_group_attachment resource separately when we use create_attachment = false
      create_attachment = false
      name_prefix                       = "mytg1-"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      protocol_version = "HTTP1"

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      } # End of health_check Block
      tags = local.common_tags  # target_group tags
    } # End of taget-group-1:mytg1 Block

    # Target Group-2: mytg2
    mytg2 = {
      # VERY IMPORTANT: We will create aws_lb_target_group_attachment resource separately when we use create_attachment = false
      create_attachment = false
      name_prefix                       = "mytg2-"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      protocol_version = "HTTP1"

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app2/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      } # End of health_check Block
      tags = local.common_tags  # target_group tags
    } # End of taget-group-2:mytg2 Block
  } # End of  target_groups

  tags = local.common_tags  # ALB Tags
} # End of alb module


resource "aws_lb_target_group_attachment" "mytg1" {
  for_each         = {for i, j in module.ec2_private_app1: i => j}   # module.ec2_private redirects to the entire private ec2 details, i redirects to the indices (i.e. 0 and 1 in our case) and j redirects to the instance details
  target_group_arn = module.alb.target_groups["mytg1"].arn
  target_id        = each.value.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "mytg2" {
  for_each         = {for i, j in module.ec2_private_app2: i => j}
  target_group_arn = module.alb.target_groups["mytg2"].arn
  target_id        = each.value.id
  port             = 80
}


## i = indices of ec2_instance e.g - 0 and 1
## j = ec2_instance_details
/*
# Output block to visualize the i and j
output "i_j_private_outputs" {
  value = {for instance_idx, instance_details in module.ec2_private: instance_idx => instance_details}
}
*/
