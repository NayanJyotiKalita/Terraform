## Create Scheduled Actions

### Create Scheduled Action-1: Increase capacity during peak hours
resource "aws_autoscaling_schedule" "increase_capacity_at_9am" {
  scheduled_action_name  = "increase-capacity-at-9am"
  min_size               = 2
  max_size               = 6
  desired_capacity       = 4
  start_time             = "2016-12-11T18:00:00Z"  # Time should be provided in UTC Timezone (9am UTC = 2.30pm IST)
  recurrence             = "00 09 * * *"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}

### Create Scheduled Action-2: Decrease capacity after peak hours
resource "aws_autoscaling_schedule" "desired_capacity_at_1pm" {
  scheduled_action_name  = "decrease-capacity-at-1pm"
  min_size               = 2
  max_size               = 2
  desired_capacity       = 2
  start_time             = "2016-12-11T18:00:00Z"  # Time should be provided in UTC Timezone (1pm UTC = 6.30pm IST)
  recurrence             = "00 13 * * *"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}
