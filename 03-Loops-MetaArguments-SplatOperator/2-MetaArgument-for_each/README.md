For this file:

```hcl
data "aws_availability_zones" "my_az" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "aws_instance" "my_ec2" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = var.instance_key
  user_data = file("${path.module}/app-install.sh")
  vpc_security_group_ids = [ aws_security_group.ssh-sg.id, aws_security_group.web-sg.id ]
  # Create EC2 instance in all AZ of a VPC
  for_each = toset(data.aws_availability_zones.my_az.names)
  tags = {
    "Name" = "For-each-EC2-${each.value}"
  }     
}
```

we created this `output.tf` file:

```hcl
# Terraform Output Values

# EC2 Instance Public IP with TOSET
output "instance_public_ip_toset" {
  description = "EC2 Instance Public IP using toset"
  # value = aws_instance.my_ec2[*].public_ip  # Splat won't work here as for_each fxn doesn't create a list and splat works only on list - for_each creates maps
  value = toset([for instance in aws_instance.my_ec2: instance.public_ip])
}

# EC2 Instance Public IP with TOMAP
output "instance_public_ip_tomap" {
  value = tomap({for i, instance in aws_instance.my_ec2: i => instance.public_ip})
}

# EC2 Instance Public DNS with TOSET
output "instance_public_dns_toset" {
  description = "EC2 Instance Public DNS using toset fxn"
  value = toset([for instance in aws_instance.my_ec2: instance.public_dns])
}

# EC2 Instance Public DNS with TOMAP
output "instance_public_dns_tomap" {
  description = "EC2 Instance Public DNS using tomap fxn"
  value = tomap({for i, instance in aws_instance.my_ec2: i => instance.public_dns})
}
```

---

<img width="705" height="603" alt="image" src="https://github.com/user-attachments/assets/53a027dd-9cff-4a4c-ac8e-e9b535ed5367" />

---












