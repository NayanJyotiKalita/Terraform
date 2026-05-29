# Input Variables
# AWS Region

variable "aws_region" {
  description = "AWS Region"
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
variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "Finance"
}
