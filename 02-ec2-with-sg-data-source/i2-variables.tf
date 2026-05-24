# Input Variables

# AWS EC2 Instance Type
variable "instance_type" {
  description = "AWS EC2 instance type."
  type        = string
  default     = "t3.micro"
}

# AWS EC2 Instance Key Pair
variable "key_name" {
  description = "AWS EC2 key pair needed to access the EC2 instance for ssh connection"
  type        = string
  default     = "oregon-key"
}

# AWS Region
variable "aws_region" {
  description = "AWS region in which we want out Resources to be created"
  type        = string
  default     = "us-west-2"
}
