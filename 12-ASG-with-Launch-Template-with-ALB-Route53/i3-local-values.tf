locals {
  owners = var.business_division
  environment = var.environment
  name = "${var.business_division}-${var.environment}"
  common_tags = {
    owners = local.owners
    environment = local.environment
  }

  asg_tags = [
    {
      key                 = "Project"
      value               = "Terrafor ASG"
      propagate_at_launch = true
    },
    {
      key                 = "foo"
      value               = "bar"
      propagate_at_launch = true
    }
  ]
}
