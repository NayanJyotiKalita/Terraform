resource "aws_instance" "my_ec2" {
  ami                    = data.aws_ami.amz-linux.id
  instance_type          = var.instance_type
  user_data              = file("${path.module}/hostname.sh")
  key_name               = var.key_name
  vpc_security_group_ids = [ aws_security_group.ssh-sg.id, aws_security_group.web-sg.id ]
  tags = {
    Name                 = "ec2-user-data-with-datasource"
  }
}

