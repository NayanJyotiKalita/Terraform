# Creating Security Group - SSH Traffic
resource "aws_security_group" "ssh-sg" {
  description = "SG for SSH connection"
  name = "ssh-sg"
  ingress {
    description = "Allow Port 22"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound ip and ports"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    "Name" = "ssh-sg"
  }
}

# Creating Security Group - Web Traffic
resource "aws_security_group" "web-sg" {
  description = "SG for Web Connection"
  name = "web-sg"
  ingress {
    description = "Allow Port 80"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]  
  }

  ingress {
    description = "Allow port 443"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    description = "Allow all outbound ip and ports"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    "Name" = "web-sg"
  }
}