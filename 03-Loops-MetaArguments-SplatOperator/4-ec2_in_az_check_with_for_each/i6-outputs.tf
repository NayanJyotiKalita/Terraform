output "instance_public_ip" {
  value = toset([for instance in aws_instance.my_ec2: instance.public_ip])
}

output "instance_public_dns" {
  value = toset([for instance in aws_instance.my_ec2: instance.public_dns])
}

output "instance_public_dns2" {
  value = tomap({for i, instance in aws_instance.my_ec2: i => instance.public_dns})
}