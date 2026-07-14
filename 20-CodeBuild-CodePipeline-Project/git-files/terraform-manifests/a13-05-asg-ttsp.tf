###### Target Tracking Scaling Policies ######
# TTS - Scaling Policy-1: Based on CPU Utilization
# Define Autoscaling Policies and Associate them to Autoscaling Group

resource "aws_autoscaling_policy" "avg_cpu_greater_than_50" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  name                   = "${local.name}-avg-cpu-policy-greater-than-50"
  policy_type            = "TargetTrackingScaling"    # Note: The policy type, either "SimpleScaling", "StepScaling" or "TargetTrackingScaling". If this value isn't provided, AWS will default to "SimpleScaling."
  estimated_instance_warmup = 180   # defaults to ASG default cooldown 300 seconds if not set
  
  # CPU Utilization is above 50
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

# TTS - Scaling Policy-2: Based on ALB Target Requests
resource "aws_autoscaling_policy" "alb_target_requests_greater_than_10" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  name                   = "${local.name}-alb-targer-requests-greater-than-10"
  policy_type            = "TargetTrackingScaling"    # Note: The policy type, either "SimpleScaling", "StepScaling" or "TargetTrackingScaling". If this value isn't provided, AWS will default to "SimpleScaling."
  estimated_instance_warmup = 120   # defaults to ASG default cooldown 300 seconds if not set
  
  # Number of requests > 10 completed per target in an Application Load Balancer target group.
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = "${module.alb.arn_suffix}/${module.alb.target_groups["tg"].arn_suffix}"
    }
    target_value = 10.0
  }
}

output "asg_build_resource_label" {
  value = "${module.alb.arn_suffix}/${module.alb.target_groups["tg"].arn_suffix}"
}

