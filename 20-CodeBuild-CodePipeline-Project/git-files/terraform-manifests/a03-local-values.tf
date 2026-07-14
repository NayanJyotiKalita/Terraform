locals {
  name = "${var.team}-${var.environment}"
  owners = var.team
  environment = var.environment
  common_tags = {
    owners = local.owners
    environment = local.environment
  }

  asg_tags = [
    {
      key                 = "Project"
      value               = "Terraform ASG"
      propagate_at_launch = true
    },
    {
      key                 = "Project for"
      value               = "CodePipeline"
      propagate_at_launch = true
    }
  ]
}
