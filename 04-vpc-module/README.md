# Normal Module

We have the below file:

`i1-versions.tf`:
```hcl
terraform {
  required_version = "~> 1.15.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.47"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

`i2-generic-variables.tf`
```hcl
variable "aws_region" {
  description = "The Region in which our resources will get created"
  type = string
  default = "us-west-2"
}
```
AND
`i3-vpc.tf`
```hcl
# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"  # best to use the lastest one with the "=" sign, not "~>" or ">"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]

  # Database Subnets
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true

  # create_database_nat_gateway_route = true  # Use when needed
  # create_database_internet_gateway_route    # Never use it in production

  # NAT Gateways - Outbound Communication (One NAT per AZ)
  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    type = "public-subnets"
  }

  private_subnet_tags = {
    type = "private-subnets"
  }

  database_subnet_tags = {
    type = "database-subnets"
  }

  tags = {
    owner = "haskell"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "dev-vpc"
  }
}
```

And after running `terraform apply`, we can observe all the resources in the console:

---

<img width="1626" height="639" alt="image" src="https://github.com/user-attachments/assets/ad0849ae-ea6d-47e5-9537-29240ed1aa1f" />

---

<img width="1480" height="307" alt="image" src="https://github.com/user-attachments/assets/cc64b18e-d7bb-4fdb-a536-43e974327d6f" />

---

<img width="907" height="300" alt="image" src="https://github.com/user-attachments/assets/9ffe53c1-0ef2-4fd5-b3a4-b2d545df9990" />

---

<img width="907" height="134" alt="image" src="https://github.com/user-attachments/assets/06bc800e-9706-4f21-ae3f-7727ede55dad" />

---

<img width="361" height="180" alt="image" src="https://github.com/user-attachments/assets/1e13dba3-145a-4e30-9342-82e877e0746d" />

---

<img width="910" height="172" alt="image" src="https://github.com/user-attachments/assets/8c99ef2a-2dba-44f6-93d3-866c285394bc" />

---

<img width="1623" height="609" alt="image" src="https://github.com/user-attachments/assets/9f80b6b5-c79d-43ce-a1a9-cb30b34ade88" />

---

<img width="1631" height="177" alt="image" src="https://github.com/user-attachments/assets/25d3a58a-24c5-43d4-90de-2a105c80b9d1" />

---

# Standardized Module

We have same versions file 

In the generic variables files, we add:

```hcl
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
```

We wrote one local values file for local naming which can help us write modular files to fetch the values for resources available locally in the module

```hcl
# Define Local Values in Terraform
locals {
  owners = var.business_division
  environment = var.environment
  name = "${var.business_division}-${var.environment}"
  # name = "${local.owners}-${local.environment}"  --> can use this too
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
}
```

Unlike last time where we hardcoded all the values for each arguments, we variabalise them:

```hcl
# VPC Input Variables

# VPC Name
variable "vpc_name" {
  description = "VPC Name"
  type = string
  default = "my-vpc"
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type = string
  default = "10.0.0.0/16"
}

# VPC Availability Zones
variable "vpc_azs" {
  description = "VPC Availability Zones"
  type = list(string)
  default = ["us-west-2a", "us-west-2b"]
}

# VPC Public Subnets
variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

# # VPC Private Subnets
variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type = list(string)
  default = [ "10.0.11.0/24", "10.0.12.0/24" ]
}

# VPC Database Subnets
variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type = list(string)
  default = [ "10.0.21.0/24", "10.0.22.0/24" ]
}

# VPC Create Database Subnet Group (True / False)
variable "vpc_create_database_subnet_group" {
  description = "VPC Create Database Subnet Group"
  type = bool
  default = true
}

# VPC Create Database Subnet Route Table (True or False)
variable "vpc_create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type = bool
  default = true   
}

# VPC Enable NAT Gateway (True or False) 
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type = string
  default = true
}

# VPC Single NAT Gateway (True or False)
variable "vpc_single_nat_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs during our demos"
  type = bool
  default = false
}

# VPC One NAT Gateway per AZ (True or False)
variable "vpc_one_nat_gateway_per_az" {
  description = "Enable one NAT Gateway in each Availabilty Zone for smoother communication in production env"
  type = bool
  default = true  
}
```

The VPC file looks much cleaner:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name = "${local.name}-${var.vpc_name}"
  cidr = var.vpc_cidr_block
  azs = var.vpc_azs
  public_subnets = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  # Database Subnets
  database_subnets = var.vpc_database_subnets
  create_database_subnet_group = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  # This usage of variables replaces the use of writing the hardcoded values for each identifier
  # e.g. : create_database_internet_gateway_route = true
         # create_database_nat_gateway_route = true
  
  # NAT Gateways - Outbound Communication (One NAT per AZ)
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway
  one_nat_gateway_per_az = var.vpc_one_nat_gateway_per_az

  # VPC DNS Parameters (we variablise these too)
  enable_dns_hostnames = true  
  enable_dns_support   = true
  
  tags = local.common_tags
  vpc_tags = local.common_tags


  public_subnet_tags = {
    type = "public-subnets"
  }

  private_subnet_tags = {
    type = "private-subnets"
  }

  database_subnet_tags = {
    type = "database-subnets"
  }
}
```

We have also written an output file

```hcl
# VPC Output Values

# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value = module.vpc.vpc_cidr_block
}

# VPC AZs
output "vpc_azs" {
  description = "The list of availability zones in this VPC"
  value = module.vpc.azs
}

# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of the public subnets"
  value = module.vpc.public_subnets
}

# VPC Private Subnets
output "private_subnets" {
  description = "List of IDs of the private subnets"
  value = module.vpc.private_subnets
}

# VPC Database Subnets
output "database_subnets" {
  description = "List of IDs of the database subnets"
  value = module.vpc.database_subnets
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value = module.vpc.nat_public_ips
}
```

---

<img width="345" height="516" alt="image" src="https://github.com/user-attachments/assets/9e61ea18-8982-4c7d-a0fa-4a1e2003e9f2" />

---
We have also added an `.tfvars` file which can be used to replace the values given in the variables file and the `.auto.tfvars` helps in automatically loading 
these values into terraform otherwise we would have to mention in the cli what our .tfvars file is. We can also put values in `.auto.tfvars` file too.

`terraform.tfvars`:
```hcl
aws_region = "us-west-2"
environment = "qa"
business_division = "SAP"
```
`vpc.auto.tfvars`:
```hcl
# We can provide different values for different configurations if we want and these values will overtake the values mentioned in the variables.tf file
# We have kept the values same as what we kept in the variables file but we can change them however we want 
vpc_name = "myvpc"
vpc_cidr_block = "10.0.0.0/16"
vpc_azs = ["us-west-2a", "us-west-2b"]
vpc_public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
vpc_database_subnets= ["10.0.21.0/24", "10.0.22.0/24"]
vpc_create_database_subnet_group = true 
vpc_create_database_subnet_route_table = true   
vpc_enable_nat_gateway = true  
vpc_single_nat_gateway = false
vpc_one_nat_gateway_per_az = true
```

Here in the `.tfvars` file, we changed the environment from dev to qa and business_division from Finance to SAP, in `.auto.tfvars`, we have changed the 
vpc name from my-vpc to myvpc and it gets impacted:

---

<img width="1610" height="635" alt="image" src="https://github.com/user-attachments/assets/0aa96fcf-d293-477c-9150-4fcb044ab0b1" />

---

So if we observe that instead of the name being `Finance-dev-my-vpc`, it has become `SAP-qa-myvpc`. </br>

This helps in keeping the original configurations intact, and inject whatever new configuration we want.

So if change the configuration in the `.auto.tfvars`:

```hcl
vpc_name = "my-vpc"
aws_region = "us-west-1"
vpc_cidr_block = "10.1.0.0/16"
vpc_azs = ["us-west-1c", "us-west-1d"]
vpc_public_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
vpc_private_subnets = ["10.1.11.0/24", "10.1.12.0/24"]
vpc_database_subnets= ["10.1.21.0/24", "10.1.22.0/24"]
vpc_create_database_subnet_group = true 
vpc_create_database_subnet_route_table = true   
vpc_enable_nat_gateway = true  
vpc_single_nat_gateway = false
vpc_one_nat_gateway_per_az = true
```

We can see the changes it's going to create in the planning stage:

---

<img width="855" height="717" alt="image" src="https://github.com/user-attachments/assets/b991fc4a-4c7d-449a-b8ae-589021c8c113" />

---






















