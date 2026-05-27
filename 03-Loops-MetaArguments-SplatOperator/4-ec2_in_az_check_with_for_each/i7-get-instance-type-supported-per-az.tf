# Get List of Availability Zones in a Specific Region
# Region is set in c1-versions.tf in Provider Block
# Datasource-1
data "aws_availability_zones" "my_az" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Check if that respective Instance Type is supported in that Specific Region in list of availability Zones
# Get the List of Availability Zones in a Particular region where that respective Instance Type is supported
# Datasource-2
data "aws_ec2_instance_type_offerings" "available_types" {
  for_each = toset(data.aws_availability_zones.my_az.names)
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }

  filter {
    name   = "location"
    values = [each.key]
  }

  location_type = "availability-zone"
}


output "output_i7_1" {
  value = {
    for i, instance in data.aws_ec2_instance_type_offerings.available_types: i => instance.instance_types
  }
}

output "output_i7_2" {
  value = {
    for i, instance in data.aws_ec2_instance_type_offerings.available_types: 
    i => instance.instance_types if length(instance.instance_types) != 0 
  }
}

output "output_i7_3" {
  value = keys({
    for i, instance in data.aws_ec2_instance_type_offerings.available_types: 
    i => instance.instance_types if length(instance.instance_types) != 0
  })
}

output "output_i7_4" {
  value = keys({
    for i, instance in data.aws_ec2_instance_type_offerings.available_types:
    i => instance.instance_types if length(instance.instance_types) != 0})[1]
}