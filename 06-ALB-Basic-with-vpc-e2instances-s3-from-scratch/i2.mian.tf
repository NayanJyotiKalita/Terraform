resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-2"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-internet-gateway"
  }
}

resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "my-route-table"
  }
}

resource "aws_route_table_association" "rt-association1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_route_table_association" "rt-association2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.myrt.id
}


# Security Group for the instances
resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "All ssh and http traffic into it and all traffic out of it"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "web_sg-1"
  }
}

/*
NOTE:
Avoid using the ingress and egress arguments of the aws_security_group resource to configure
in-line rules, as they struggle with managing multiple CIDR blocks, and, due to the historical 
lack of unique IDs, tags and descriptions. To avoid these problems, we use the current best 
practice of the aws_vpc_security_group_egress_rule and aws_vpc_security_group_ingress_rule resources 
with one CIDR block per rule.
*/

resource "aws_vpc_security_group_ingress_rule" "ingress_80" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags = {
    "Name" = "web-sg-incoming-80"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_22" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4        = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = {
    "Name" = "web-sg-incoming-22"
  }
}

resource "aws_vpc_security_group_egress_rule" "egress_all" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  tags = {
    "Name" = "web-sg-outgoing-all"
  }
}

# S3 Bucket 
resource "aws_s3_bucket" "my_s3" {
  bucket = "nayanterraformproject-12-28-10-2026"    # -- use random_pet
}

# Data Source block for fetching the latest Amazon AMI ID
data "aws_ami" "amazon_linux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

# EC2 instance Blocks
## EC2 instance 1
resource "aws_instance" "my_instance_1" {
  ami                    = "ami-04857b2a57c905098"       # data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"       # var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.public1.id
  user_data_base64       = base64encode(file("${path.module}/userdata1.sh"))
  key_name               = "oregon-key"       # var.key_name
  tags = {
    "Name" = "my-public-instance-1" 
  }
}

## EC2 instance 2
resource "aws_instance" "my_instance_2" {
  ami                    = "ami-04857b2a57c905098"       # data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"        # var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.public2.id
  user_data_base64       = base64encode(file("${path.module}/userdata2.sh"))
  key_name               = "oregon-key"       # var.key_name
  tags = {
    "Name" = "my-public-instance-2" 
  }
}

# ALB Configurations
## Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "All ssh and http traffic into it and all traffic out of it"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "alb_sg"
  }
}

## Ingress rule for ALB SG
resource "aws_vpc_security_group_ingress_rule" "alb-ingress_80" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags = {
    "Name" = "alb-sg-incoming-80"
  }
}

## Egress rule for ALB SG
resource "aws_vpc_security_group_egress_rule" "alb-egress_all" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  tags = {
    "Name" = "alb-sg-outgoing-all"
  }
}


## ALB Resource Block
resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

## ALB Target Group Block
resource "aws_lb_target_group" "mytg" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path     = "/"
    port     = "traffic-port"
    protocol = "HTTP"
  }
}

## ALB Target Group Attachments
resource "aws_lb_target_group_attachment" "tg-attach-1" {
  target_group_arn = aws_lb_target_group.mytg.arn
  target_id        = aws_instance.my_instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg-attach-2" {
  target_group_arn = aws_lb_target_group.mytg.arn
  target_id        = aws_instance.my_instance_2.id
  port             = 80
}

# ALB Listener Block
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mytg.arn
  }
}

# Output files
output "load_balancer_dns" {
  value = aws_lb.my_alb.arn
}

output "instance_public_ip_1" {
  value = aws_instance.my_instance_1.public_ip
}

output "instance_public_ip_2" {
  value = aws_instance.my_instance_2.public_ip
}

