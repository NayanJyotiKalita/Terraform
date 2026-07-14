variable "aws_region" {
  description = "Region in which our Resources will get provisioned"
  type = string
  default = "us-west-2"
}

# Environment Variable
variable "environment" {
  description = "Environment variable to be used a prefix"
  type = string
  default = "dev"
}

# Business Division
variable "team" {
  description = "The Team which manages the entire infrastructure"
  type = string
  default = "DevOps"
}