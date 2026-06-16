## Create Scheduled Actions
### Create Scheduled Action-1: Increase capacity during business hours
resource "aws_autoscaling_schedule" "increase_capacity_9am" {
  scheduled_action_name  = "increase-capacity-at-9am"
  min_size               = 2
  max_size               = 6
  desired_capacity       = 4
  start_time             = "2026-06-17T09:02:00Z"  # Time should be provided in UTC Timezone (11am UTC = 7AM EST)
  recurrence             = "00 09 17 * *"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}

### Create Scheduled Action-2: Decrease capacity during business hours
resource "aws_autoscaling_schedule" "decrease_capacity_6pm" {
  scheduled_action_name  = "decrease-capacity-at-6pm"
  min_size               = 2
  max_size               = 5
  desired_capacity       = 2
  start_time             = "2026-06-17T09:05:00Z"  # Time should be provided in UTC Timezone (11am UTC = 7AM EST)
  recurrence             = "00 21 17 * *"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}

