# AWS EC2 Instance Terraform Outputs

# Public EC2 Instances - Bastion Host
## ec2_bastion_public_instance_ids
output "ec2_bastion_instance_id" {
  description = "The ID of the public/bastion instance"
  value       = module.ec2_bastion.id
}

## ec2_bastion_public_ip
output "ec2_bastion_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.ec2_bastion.public_ip
}

# elastic_ip
output "elastic_ip" {
  description = "IP Address of the elastic IP"
  value = aws_eip.public_elastic_ip.public_ip
}

# Private EC2 Instances for app1
## ec2_private_instance_ids
output "ec2_private_instance_ids_1" {
  description = "List of IDs of private instances"
  value       = [for private in module.ec2_private_app1: private.id]
}

## ec2_private_ip
output "ec2_private_ip_1" {
  description = "List of private IP assigned to the private instances"
  value       = [for private in module.ec2_private_app1: private.private_ip]
}

# Private EC2 Instances for app2
## ec2_private_instance_ids
output "ec2_private_instance_ids_2" {
  description = "List of IDs of private instances"
  value       = [for private in module.ec2_private_app2: private.id]
}

## ec2_private_ip
output "ec2_private_ip_2" {
  description = "List of private IP assigned to the private instances"
  value       = [for private in module.ec2_private_app2: private.private_ip]
}