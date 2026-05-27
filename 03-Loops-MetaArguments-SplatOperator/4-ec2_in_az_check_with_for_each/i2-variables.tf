variable "aws_region" {
  description = "The Region in which our Resources will get provisioned"
  type = string
  default = "us-east-1"
}

variable "instance_key" {
  description = "The key with which we will connect to our instace for SSH"
  type = string
  default = "my-pem-key"
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = "t3.micro"
}

variable "instance_type_list" {
  description = "EC2 instance type in list format"
  type = list(string)
  default = [ "t3.nano", "t3.micro", "t3.small" ]
}

variable "instance_type_map" {
  description = "EC2 instance type in map format"
  type = map(string)
  default = {
    "dev" = "t3.nano"
    "qa"  = "t3.micro"
    "prod" = "t3.small"
  }
}