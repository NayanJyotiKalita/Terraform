For the below resource, data and output files:
```hcl
resource "aws_instance" "my_ec2" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = var.instance_key
  user_data = file("${path.module}/app-install.sh")
  vpc_security_group_ids = [ aws_security_group.ssh-sg.id, aws_security_group.web-sg.id ]
  # Create EC2 Instance in all Availabilty Zones of a VPC 
  # for_each = toset(data.aws_availability_zones.my_az.names)
  for_each = toset(keys({for i, instance in data.aws_ec2_instance_type_offerings.available_types: 
    i => instance.instance_types if length(instance.instance_types) != 0}))
  availability_zone = each.key  # We can also use each.value because for list items each.key == each.value
  tags = {
    "Name" = "For-Each-EC2-${each.key}"
  }     
}
```
```hcl
output "instance_public_ip" {
  value = toset([for instance in aws_instance.my_ec2: instance.public_ip])
}

output "instance_public_dns" {
  value = toset([for instance in aws_instance.my_ec2: instance.public_dns])
}

output "instance_public_dns2" {
  value = tomap({for i, instance in aws_instance.my_ec2: i => instance.public_dns})
}
```
```hcl
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
```
 We get the following details as output after running the `terraform apply` command:

```
instance_public_dns = toset([
  "ec2-44-220-62-84.compute-1.amazonaws.com",
  "ec2-52-87-205-248.compute-1.amazonaws.com",
  "ec2-54-198-19-60.compute-1.amazonaws.com",
  "ec2-54-85-47-187.compute-1.amazonaws.com",
  "ec2-98-92-233-231.compute-1.amazonaws.com",
])
instance_public_dns2 = tomap({
  "us-east-1a" = "ec2-98-92-233-231.compute-1.amazonaws.com"
  "us-east-1b" = "ec2-52-87-205-248.compute-1.amazonaws.com"
  "us-east-1c" = "ec2-54-85-47-187.compute-1.amazonaws.com"
  "us-east-1d" = "ec2-54-198-19-60.compute-1.amazonaws.com"
  "us-east-1f" = "ec2-44-220-62-84.compute-1.amazonaws.com"
})
instance_public_ip = toset([
  "44.220.62.84",
  "52.87.205.248",
  "54.198.19.60",
  "54.85.47.187",
  "98.92.233.231",
])
output_i7_1 = {
  "us-east-1a" = tolist([
    "t3.micro",
  ])
  "us-east-1b" = tolist([
    "t3.micro",
  ])
  "us-east-1c" = tolist([
    "t3.micro",
  ])
  "us-east-1d" = tolist([
    "t3.micro",
  ])
  "us-east-1e" = tolist([])
  "us-east-1f" = tolist([
    "t3.micro",
  ])
}
output_i7_2 = {
  "us-east-1a" = tolist([
    "t3.micro",
  ])
  "us-east-1b" = tolist([
    "t3.micro",
  ])
  "us-east-1c" = tolist([
    "t3.micro",
  ])
  "us-east-1d" = tolist([
    "t3.micro",
  ])
  "us-east-1f" = tolist([
    "t3.micro",
  ])
}
output_i7_3 = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c",
  "us-east-1d",
  "us-east-1f",
]
output_i7_4 = "us-east-1b"
```

We can see the names of the instances corresponding to the AZ because our code logic was redirecting to the AZ names from the `each.key` used in the tags.

---

<img width="1045" height="185" alt="Screenshot 2026-05-26 223756" src="https://github.com/user-attachments/assets/deb7686a-8274-482b-99f2-a47a91899722" />

---

Once we destroy, everything gets deleted:

---

<img width="740" height="167" alt="Screenshot 2026-05-26 223953" src="https://github.com/user-attachments/assets/5510cf42-264b-45f1-80c5-6be9bea66ad2" />

---

---<img width="1036" height="181" alt="Screenshot 2026-05-26 224028" src="https://github.com/user-attachments/assets/d739ef94-5403-45b8-80de-dfcd09a6e918" />

---














