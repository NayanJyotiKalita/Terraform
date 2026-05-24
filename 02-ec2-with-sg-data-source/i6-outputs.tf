output "instance_public_ip" {
  description = "EC2 Instance Public IP"
  value = aws_instance.my_ec2.public_ip
}

output "instance_private_ip" {
  description = "EC2 Instance Private IP"
  value = aws_instance.my_ec2.private_ip
}

output "instance_public_dns" {
  description = "EC2 Instance Public DNS"
  value = aws_instance.my_ec2.public_dns
}

output "instance_private_dns" {
  description = "EC2 Instance Private DNS"
  value = aws_instance.my_ec2.private_dns
}