# Terraform AWS Application Load Balancer (ALB) with Custom VPC, EC2 Instances & S3 - From Scratch
---
---

<img width="1536" height="1024" alt="ChatGPT Image Jun 11, 2026, 12_24_40 PM" src="https://github.com/user-attachments/assets/6cf6a923-b50d-4494-a968-2743e7c93df1" />

---
---

## Overview

This project provisions a complete AWS infrastructure using Terraform from scratch, including:

* Custom VPC
* Public Subnets across multiple Availability Zones
* Internet Gateway
* Route Tables and Route Associations
* Security Groups
* EC2 Instances running Apache Web Server
* Application Load Balancer (ALB)
* Target Group and Listener Configuration
* S3 Bucket 
* Outputs for infrastructure access

The project demonstrates Infrastructure as Code (IaC) principles by automating the deployment of a highly available web application architecture on AWS.

---

## Technologies Used

* Terraform
* AWS VPC
* AWS EC2
* AWS Application Load Balancer (ALB)
* AWS Security Groups
* AWS S3
* Amazon Linux
* Apache HTTP Server

---

## AWS Resources Created

| Resource                  | Purpose                        |
| ------------------------- | ------------------------------ |
| VPC                       | Isolated network environment   |
| Public Subnets            | Host internet-facing resources |
| Internet Gateway          | Enable internet access         |
| Route Tables              | Traffic routing                |
| Security Groups           | Network access control         |
| EC2 Instances             | Web servers                    |
| Target Group              | ALB backend registration       |
| Application Load Balancer | Traffic distribution           |
| Listener                  | HTTP request handling          |
| S3 Bucket                 | Bucket creation                |

---

## Project Structure

```text
.
├── i1-versions.tf
├── i2-provider.tf
├── i3-vpc-variables.tf
├── i3-vpc.tf
├── i -ec2-securitygroups-variables.tf
├── i4-ec2-securitygroups.tf
├── i -ec2instance-variables.tf
├── i5-ec2instances.tf
├── i6-alb.tf
├── i7-outputs.tf
├── terraform.tfvars
├── userdata1.sh
├── userdata2.sh
└── README.md
```

> File names may vary slightly depending on your implementation.

---

## Prerequisites

Before deploying, ensure you have:

* AWS Account
* IAM User with appropriate permissions
* AWS CLI configured
* Terraform installed
* Git installed

Verify installation:

```bash
terraform -version
aws --version
```

---

## Deployment Steps

### Clone Repository

```bash
git clone https://github.com/NayanJyotiKalita/Terraform.git
cd Terraform/06-ALB-Basic-with-vpc-e2instances-s3-from-scratch
```

### Initialize Terraform

```bash
terraform init
```

### Validate Configuration

```bash
terraform validate
```

### Review Execution Plan

```bash
terraform plan
```

### Deploy Infrastructure

```bash
terraform apply -auto-approve    # only in demo, not in production --> use terraform apply
```

---

## Verification

After deployment:

### Check ALB DNS

```bash
terraform output
```

Copy the ALB DNS name and open it in your browser.

Example:

```text
http://my-alb-123456.us-east-1.elb.amazonaws.com
```
---
---

<img width="855" height="237" alt="Screenshot 2026-06-10 212235" src="https://github.com/user-attachments/assets/3dcd9da1-3836-4ca0-9eeb-9bb660489829" />

---

<img width="856" height="222" alt="Screenshot 2026-06-10 212254" src="https://github.com/user-attachments/assets/bc6b71c1-c4ce-46fe-a5f8-e702e1a21110" />

---
---

You should see responses from the backend EC2 instances.

---

<img width="1108" height="833" alt="Screenshot 2026-06-10 212705" src="https://github.com/user-attachments/assets/1a065a13-a511-4ec1-814c-865109d2df37" /> 

---

## Terraform Commands

### View Resources

```bash
terraform state list
```

### View Outputs

```bash
terraform output
```

### Destroy Infrastructure

```bash
terraform destroy
```

---

## Learning Objectives

This project demonstrates:

* Infrastructure as Code (IaC)
* AWS Networking Fundamentals
* High Availability Architecture
* Load Balancing Concepts
* Terraform Resource Dependencies
* Security Group Configuration
* Creation of S3 Bucket

---

## Cost Considerations

Resources in this project may incur AWS charges, including:

* EC2 Instances
* Application Load Balancer
* Data Transfer
* S3 Storage

Always destroy resources when not in use:

```bash
terraform destroy
```

---

## Future Enhancements

* HTTPS using AWS Certificate Manager (ACM)
* Route53 DNS Integration
* Auto Scaling Group
* Launch Templates
* Multi-tier Architecture
* WAF Integration
* CloudWatch Monitoring
* CI/CD using GitHub Actions

---

## Author

**Nayan Jyoti Kalita**

* GitHub: https://github.com/NayanJyotiKalita
* LinkedIn: https://www.linkedin.com/in/nayan-jyoti-kalita-devops-cloud-sre/

---

