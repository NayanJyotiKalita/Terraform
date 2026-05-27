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


