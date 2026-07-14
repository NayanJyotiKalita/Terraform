variable "vpc_name" {
  description = "VPC Name"
  type = string
  default = "my-vpc"
} 

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type = string
  default = "10.0.0.0/16"
} 

variable "vpc_azs" {
  description = "VPC Availability Zones"
  type = list(string)
  default = ["us-west-2a", "us-west-2b"]
}

variable "private_subnets" {
  description = "VPC Private Subnets"
  type = list(string)
  default = [ "10.0.101.0/24", "10.0.102.0/24" ]
}

variable "public_subnets" {
  description = "VPC Public Subnets"
  type = list(string)
  default = [ "10.0.111.0/24", "10.0.112.0/24" ]
}

variable "database_subnets" {
  description = "VPC Database Subnets"
  type = list(string)
  default = [ "10.0.121.0/24", "10.0.122.0/24" ]
}

variable "create_database_subnet_group" {
  description = "VPC Create Database Subnet Group"
  type = bool
  default = true
}

variable "create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type = bool
  default = true
}
  
variable "enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type = string
  default = true
}

variable "single_nat_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs during our demos"
  type = bool
  default = true
}

variable "one_nat_gateway_per_az" {
  description = "Enable one NAT Gateway in each Availabilty Zone for smoother communication in production env"
  type = bool
  default = false
}