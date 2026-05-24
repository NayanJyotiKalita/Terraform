resource "aws_instance" "my_ec2" {
  ami           = "ami-09ed39e30153c3bf9"
  instance_type = "t3.micro"
  user_data = file("${path.module}/hostname.sh")
  tags = {
    Name = "ec2-instance-with-user-data"
  }
}
