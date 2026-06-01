# Provisioning Public (Bastion Host) and Private Instances in a Three-Tier VPC Architecture

## Concepts Used - NAT Gateway, Elastic IP, Bastion Host, Secure Private Instances, Null Resources - File/Remote-Exec/Local-Exec Provisioners

In this module, we are going a few more steps ahead by trying to create three VPC Architecture along with launching public and private instances with elastic ips attached to the public instance and making the public instance as a bastion host for the private instances to connect to the internet securely </br>

You can check out the files here: [/05-ec2-with-sg-vpc-eip-exec](/05-ec2-with-sg-vpc-eip-exec) but I am going to mention here the new files added on top of the previous modueles and the changes that I have tried. </br>

In the `vpc-variables` file, we have changed the configuration to setup only one one NAT Gateway in the entire VPC using the following configuration: </br>

```hcl
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
  default = true  # We have changed this value here as compared to the last example as we need only one nat
}

# VPC One NAT Gateway per AZ (True or False)
variable "vpc_one_nat_gateway_per_az" {
  description = "Enable one NAT Gateway in each Availabilty Zone for smoother communication in production env"
  type = bool
  default = false  # We have changed this value too due to the same reason as we need don't one nat in each az
}
```

---

## Security Groups

We have added three files for the security groups as we are using modules for creating security groups: </br>

### One Security Group for the bastion host i.e. the public instance: </br>

`i5-01-sg-bastionsg.tf` - This file defines the inbound and outbound permissions given to the public instance(s) 
```hcl
module "public_bastion_sg" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "5.3.1"

  name                     = "public-bastion-security-group"
  description              = "Security Group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id                   = module.vpc.vpc_id 

  # Ingress Rules & CIDR Blocks  --> Modules have have way of defining the below parameters
  ingress_rules            = ["ssh-tcp"]    # We need only the ssh traffic to come through it because we will use our public instance as a platform to connect to the private instance
  ingress_cidr_blocks      = ["0.0.0.0/0"]
  
  # Egress Rule - all-all open
  egress_rules             = ["all-all"]

  tags = local.common_tags

}
```

### Another Security Group for the private instance which will be hosting the web server:

`i5-01-sg-prviatesg.tf` - This file defines the inbound and outbound permissions given to the instance(s) 
```hcl
module "private_sg" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "5.3.1"

  name                     = "private-security-group"
  description              = "Security Group with HTTP & SSH port open for the VPC i.e the internal traffic, egress ports are all world open"
  vpc_id                   = module.vpc.vpc_id 

  # Ingress Rules & CIDR Blocks for ssh and http for internal traffic
  ingress_rules            = ["ssh-tcp", "http-80-tcp"]    # Here we need these two rules as we need to enter the private instance via ssh from the public instance and the http 80 rule to access our web server
  ingress_cidr_blocks      = [module.vpc.vpc_cidr_block]     # This defines that the traffic can come only within the vpc, not from the outside world, enhancing the security

  # Egress Rule - all-all open
  egress_rules             = ["all-all"]

  tags = local.common_tags
}
```

---

There is another output file for the security groups, you can check it our here: [i5-03-sg-outputs.tf](/05-ec2-with-sg-vpc-eip-exec/i5-03-sg-outputs.tf)

The output file is written basically to give us the Security Group IDs, VPC IDs, Securtiy Group Names and the Security Group Owner IDs of the both the Security Groups that we created

---

## EC2 Instances

### In our vaiables file for the instances, we added:

```hcl
# AWS EC2 Private Instance Count
variable "private_instance_count" {
  description = "AWS EC2 private instance count"
  type = number
  default = 1
}
```

### Our ec2 module for the public/bastion instance:

`i7-03-ec2-bastion.tf`
```hcl
# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_bastion" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "6.4.0"

  name                   = "${var.environment}-BastionHost"

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.keypair 
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  tags                   = local.common_tags
}
```

### Our ec2 module for the private instance:

`i7-04-ec2-private.tf`
```hcl
# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Private Subnet
module "ec2_private" {
  depends_on = [ module.vpc ]
  source     = "terraform-aws-modules/ec2-instance/aws"
  version    = "6.4.0"

  name                   = "${var.environment}-private"
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.keypair 
  user_data              = file("${path.module}/app-install.sh")
  tags                   = local.common_tags
  vpc_security_group_ids = [module.private_sg.security_group_id]

  # instance_count is deprecated
  # instance_count         = var.private_instance_count
  # subnet_ids = [module.vpc.private_subnets[0],module.vpc.private_subnets[1] ]

  # We for_each now instead of instance_count
  for_each               = toset([for i in range(var.private_instance_count) : tostring(i)])
  subnet_id              = element(module.vpc.private_subnets, tonumber(each.key))
}
```

`i7-02-ec2-outputs.tf`
```hcl
# AWS EC2 Instance Terraform Outputs

# Public EC2 Instances - Bastion Host
## ec2_bastion_public_instance_ids
output "ec2_bastion_instance_id" {
  description = "The ID of the public/bastion instance"
  value       = module.ec2_bastion.id
}

## ec2_bastion_public_ip
output "ec2_bastion_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached --> we will check our output and verify this"
  value       = module.ec2_bastion.public_ip
}

# Private EC2 Instances
## ec2_private_instance_ids
output "ec2_private_instance_ids" {
  description = "List of IDs of private instances"
  value       = [for private in module.ec2_private: private.id]
}

## ec2_private_ip
output "ec2_private_ip" {
  description = "List of private IP assigned to the private instances"
  value       = [for private in module.ec2_private: private.private_ip]
}
```

---

## Null Resource - File/Remote-Exec/Local-Exec Provisioners

Our scenario needs us to use the bastion host to have the `.pem` file inside it to connect to the private instance and we don't want to touch the bastion instance via the console, we want to automate it using Terraform and so we use the `Null Resource` block to do the same thing. It establishes the connection with the instance and then using the `file provisioner` it copies the `.pem` file and then using the `remote-exec provisioner` it changes the permission of the `.pem` file. </br>

We also used the `local-exec provisioner` to do something inside our module, we will observe it once we apply our configurations

`i9-nullresource-provisioners.tf`
```hcl
# Create a Null Resource and Provisioners
resource "null_resource" "cluster" {
  depends_on    = [ module.ec2_bastion ]    # The null resource connection needs to happen with the bastion host and that's why it's important for the bastion host to get created before the Null Resource
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = aws_eip.public_elastic_ip.public_ip
    user        = "ec2-user"  # use ubuntu if you are using ubuntu linux for your ami or you can use root if you are using the root user
    password    = ""
    private_key = file("oregon-key.pem")
  }

# File Provisioner: Copies the oregon-key.pem file to /tmp/oregon-key.pem
  provisioner "file" {
    source      = "oregon-key.pem"
    destination = "/tmp/oregon-key.pem"
  }

# Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" { 
    inline      = [
      "sudo chmod 400 /tmp/oregon-key.pem"
    ]
  } 

# Local Exec Provisioner:  local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command     = "echo Public EC2 created on `data` and Instance ID: ${module.ec2_bastion.id} >> creation-time-public-ec2-id"
    working_dir = "local-exec-output-files/"    # We create this dir inside our module and the output will be created inside it
  }
}
```

---

## .auto.tfvars file

This time, along with the `vpc_name`, we changed the subnet ranges to see some proper changes that comes into effect as a result of the `.auto.tfvars` file:

```hcl
vpc_name                                = "myvpc"
vpc_cidr_block                          = "10.0.0.0/16"
vpc_azs                                 = ["us-west-2a", "us-west-2b"]
vpc_public_subnets                      = ["10.0.101.0/24", "10.0.102.0/24"]
vpc_private_subnets                     = ["10.0.111.0/24", "10.0.112.0/24"]
vpc_database_subnets                    = ["10.0.121.0/24", "10.0.122.0/24"]
vpc_create_database_subnet_group        = true 
vpc_create_database_subnet_route_table  = true   
vpc_enable_nat_gateway                  = true  
vpc_single_nat_gateway                  = true
vpc_one_nat_gateway_per_az              = true
```

---





---


```
Apply complete! Resources: 46 added, 0 changed, 0 destroyed.

Outputs:

database_subnets = [
  "subnet-066fe67f36e130b20",
  "subnet-031fc58a43ffea207",
]
ec2_bastion_instance_id = "i-0bb20e081c452f641"
ec2_bastion_public_ip = ""                          --> We can see the public instance doesn't have the public ip because we have also assigned an elastic ip which overrides the public ip and as we have not mentioned the elastic ip output in our output file, so we are not able to fetch the ip
ec2_private_instance_ids = [
  "i-05fbee39a753d16e2",
  "i-0a882d78b09b9652e",
]
ec2_private_ip = [
  "10.0.111.124",
  "10.0.112.244",
]
nat_public_ips = tolist([
  "44.241.190.12",
])
private_bastion_sg_group_id = "sg-0153c76ca1c0b1c21"
private_sg_group_name = "private-security-group-20260531124334811200000002"
private_sg_group_vpc_id = "vpc-09246c56c0091bf7b"
private_sg_owner_id = "202512444928"
private_subnets = [
  "subnet-032375822fd801dba",
  "subnet-0382aacb08ad6a3a3",
]
public_bastion_sg_group_id = "sg-05772c6caf16d5f7f"
public_bastion_sg_group_name = "public-bastion-security-group-20260531124337843900000005"
public_bastion_sg_group_vpc_id = "vpc-09246c56c0091bf7b"
public_bastion_sg_owner_id = "202512444928"
public_subnets = [
  "subnet-0089b48d0cfeb00b1",
  "subnet-0ee52476575f9dca5",
]
vpc_azs = tolist([
  "us-west-2a",
  "us-west-2b",
])
vpc_cidr_block = "10.0.0.0/16"
vpc_id = "vpc-09246c56c0091bf7b"
```

---

<img width="713" height="233" alt="image" src="https://github.com/user-attachments/assets/a4f63243-f44e-4193-a1e3-644965fc6825" />

---

We added a new output block:

```hcl
# elastic_ip
output "elastic_ip" {
  description = "IP Address of the elastic IP"
  value = aws_eip.public_elastic_ip.public_ip
}
```

And now when we plan it, it give us the required output:

---

<img width="1262" height="654" alt="image" src="https://github.com/user-attachments/assets/74d4db5f-82c6-4ed7-985e-879e891baaad" />

---

Now, using our elasticip/public ip, we connected to the bastion_host/public_instance:

---

<img width="937" height="448" alt="image" src="https://github.com/user-attachments/assets/36a5ee88-8bac-49d9-905a-9662591840ab" />

---

Now, our web server is installed in our private instance, we need to connect to the private instance to check its status but there isn't any way that we can directly connect to it and that's where our 
`file` and `remote-exec` provisioner would work:

---

<img width="533" height="47" alt="image" src="https://github.com/user-attachments/assets/e2299716-19d9-4cea-ae00-5777a009a14e" />

---

<img width="799" height="412" alt="image" src="https://github.com/user-attachments/assets/d9245642-1a38-465f-ad90-2baa5a14af87" />

---

<img width="592" height="154" alt="image" src="https://github.com/user-attachments/assets/804a8ff6-a2f1-4fe9-9949-8b614b84b981" />

---






