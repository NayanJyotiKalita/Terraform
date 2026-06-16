# Launch Template Outputs
## launch_template_id
output "launch_template_id" {
  description = "Laucnh template ID"
  value = aws_launch_template.my_launch_template.id
}

## launch_template_latest_version
output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value = aws_launch_template.my_launch_template.latest_version
}

# Autoscaling Outputs
## autoscaling_group_id
output "autoscaling_group_id" {
  description = "Autoscaling group ID"
  value = aws_autoscaling_group.my_asg.id
}

## autoscaling_group_name
output "autoscaling_group_name" {
  description = "Autoscaling group name"
  value = aws_autoscaling_group.my_asg.name
}

## autoscaling_group_arn
output "autoscaling_group_arn" {
  description = "Autoscaling group arn"
  value = aws_autoscaling_group.my_asg.arn
}

## autoscaling_group_az
output "autoscaling_group_az" {
  description = "Autoscaling group azs"
  value = aws_autoscaling_group.my_asg.availability_zones
}