module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.0"

  name               = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.alb_sg.id]

  # For example only
  enable_deletion_protection = false

  # Listeners
  listeners = {
    # Listener-1: http-https-redirect
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    } # End http-https-redirect Listener

    # Listener-2: https-listener
    https-listener = {
      port                        = 443
      protocol                    = "HTTPS"
      ssl_policy                  = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn             = module.acm.acm_certificate_arn
    
      # Fixed Response for Root Context 
      fixed_response = {
        content_type = "text/plain"
        status_code  = 200
        message_body = "This is a fixed response"
      }

      # Load Balancer Rules
      rules = {
        myapp-rule = {
          priority = 1
          actions = [{
            weighted_forward = {
              target_groups = [
                {
                  target_group_key = "tg"
                  weight           = 1
                }
              ]
              stickiness = {
                enabled  = true
                duration = 3600
              }
            }
          }]
          conditions = [{
              path_pattern = {
                values = ["/*"]
              }
            }]
        } # End of myapp1-rule
      } # End Rules Block
    } # End https-listener Block
  } # End Listeners Block

  # Target Group
  target_groups = {
    # Target Group: tg
    tg = {
      create_attachment                 = false
      name_prefix                       = "tg-"
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
      } # End of Health Check Block
      tags = local.common_tags # Target Group Tags 
    }  # END of Target Group-1: tg
  } # END OF target_groups
  tags = local.common_tags # ALB Tags
} # End of alb module