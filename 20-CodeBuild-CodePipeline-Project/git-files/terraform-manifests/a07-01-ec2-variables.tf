# AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

# AWS EC2 Instance Key Pair
variable "key_name" {
  description = "AWS EC2 Key pair that needs to be associated with EC2 Instance"
  type        = string
  default     = "oregon-vn"
}

# AWS EC2 Private Instance Count
variable "private_instance_count" {
  description = "AWS EC2 private instance count"
  type        = number
  default     = 1
}
