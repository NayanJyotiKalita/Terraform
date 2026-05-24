# Creating EC2 instance with Security Groups, Using Variables and Data Sources

Here we are going to create an EC2 instance along with Security Groups which would allow us to SSH into the system and also access the machine on Port 80

## Step-1: Pre-requisite
Create a key pair in AWS EC2 Key pairs in the region you want to provision your resources, e.g. I have created my key in the Oregon Region so I have created a key pair named `oregon-key`
</br>
***NOTE: Never commit your PRIVATE KEY in your git repository*** 

---

## Step-2: Introduction

### What we have done here:
  1. Implemented Terraform `Input Variable` basics
  - Instance Type
  - Key Name
  - AWS Region
    
  2. Define Security Groups and Associate them as a `List item` to AWS EC2 Instance
  - ssh-sg
  - web-sg
    
  3. Used Terraform Output block to get:
  - Public IP
  - Private IP
  - Public DNS
  - Private DNS
    
  4. Get latest EC2 AMI ID Using `Terraform Datasources` concept
  5. We are also going to use existing EC2 Key pair `oregon-key` <key-that-you-create>
  6. Use all the above to create an EC2 Instance in default VPC

---

## Step-3: i2-variables.tf - Define Input Variables in Terraform
  - Variables File: [i2-variables.tf](/02-ec2-with-sg-data-source/i2-variables.tf)

```hcl
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
```

  - Reference the variables in respective .tf fies

```hcl
# i1-versions.tf
region = var.aws_region

# i5-ec2-instance.tf
instance_type = var.instance_type
key_name      = var.key_name
```

---

## Step-4: i3-security-groups.tf - Define Security Group Resources in Terraform

  - Security Groups File: [i3-security-groups.tf](/02-ec2-with-sg-data-source/i3-security-groups.tf)

```hcl
# Creating Security Group - SSH Traffic
resource "aws_security_group" "ssh-sg" {
  name = "ssh-sg"
  description = "Security group for SSH Connection"
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound ip and ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-sg"
  }
}

# # Create Security Group - Web Traffic
resource "aws_security_group" "web-sg" {
  name = "web-sg"
  description = "Security group for Web Traffic"
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow POrt 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound ip and ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    "Name" = "web-sg"
  }
}
```

  - Reference the security groups in `i5-ec2-instance.tf` file as a list item

```
vpc_security_group_ids = [ aws_security_group.ssh-sg.id, aws_security_group.web-sg.id ]
```

---

## Step-5: i4-ami-datasource.tf - Define Get Latest AMI ID for Amazon Linux3 OS

  - Data Source File: [i4-ami-datasource.tf](/02-ec2-with-sg-data-source/i4-ami-datasource.tf)

```hcl
# Get Latest AWS AMI ID for Amazon3 Linux
data "aws_ami" "amz-linux" {
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
    values = ["x86_64"]
  }
}
```

  - Reference the datasource in `i5-ec2-instance.tf` file
```hcl
# Reference Datasource to get the latest AMI ID
ami           = data.aws_ami.amz-linux.id
```

---

## Step-6: i5-ec2-instance.tf - Define EC2 Instance Resource

  - Instance Creation File: [i5-ec2-instance.tf](/02-ec2-with-sg-data-source/i5-ec2-instance.tf)

```hcl
resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.amz-linux.id
  instance_type = var.instance_type
  user_data     = file("${path.module}/hostname.sh")
  key_name      = var.key_name
  vpc_security_group_ids = [ aws_security_group.ssh-sg.id, aws_security_group.web-sg.id ]
  tags = {
    Name = "ec2-user-data-with-datasource"
  }
}
```

---

## Step-7: i6-outputs.tf - Define Output Values

  - Outputs File: [i6-outputs.tf](//02-ec2-with-sg-data-source/i6-outputs.tf)

```hcl
# Terraform Output Values
output "instance_public_ip" {
  description = "EC2 Instance Public IP"
  value = aws_instance.my_ec2.public_ip
}

output "instance_private_ip" {
  description = "EC2 Instance Private IP"
  value = aws_instance.my_ec2.private_ip
}

output "instance_public_dns" {
  description = "EC2 Instance Public DNS"
  value = aws_instance.my_ec2.public_dns
}

output "instance_private_dns" {
  description = "EC2 Instance Private DNS"
  value = aws_instance.my_ec2.private_dns
}
```

---

## Step-8: Execute Terraform Commands

```
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate
Observation:
1) If any changes to files, those will come as printed in stdout (those file names will be printed in CLI)

# Terraform Plan
terraform plan
Observation:
1) Verify the latest AMI ID picked and displayed in plan
2) Verify the number of resources that going to get created
3) Verify the variable replacements worked as expected

# Terraform Apply
terraform apply 
[or]
terraform apply -auto-approve
Observations:
1) Create resources on cloud
2) Created terraform.tfstate file when we run the terraform apply command
3) Verify the EC2 Instance AMI ID which got created
```

---

## Step-9: Access Application

```
# Access index.html
http://<PUBLIC-IP>/index.html

# in terminal
curl <<PUBLIC-IP>:80
```

`In Browser`
<img width="759" height="128" alt="image" src="https://github.com/user-attachments/assets/87ca7eb8-d214-403c-89b0-60e8fd6a4df8" />

</br>

`In Terminal`
<img width="630" height="50" alt="image" src="https://github.com/user-attachments/assets/9b055f84-9999-4d05-9abd-27e6ceaaeeef" />

---

## Step-10: Clean-Up

```
# Terraform Destroy
terraform plan -destroy  # We can view destroy plan using this command
terraform destroy

# Clean-Up Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

---











