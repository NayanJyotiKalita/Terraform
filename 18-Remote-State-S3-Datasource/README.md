## Creation of Project 1

- Copied all the files from the previous project [17-Remote-State-S3-with-DynamoDB](/17-Remote-State-S3-with-DynamoDB/)
- Put them in a directory called project1-vpc

### Project 1 initialization

---

<img width="809" height="441" alt="Screenshot 2026-06-25 005457" src="https://github.com/user-attachments/assets/5b01291c-3b1b-42cf-8996-4d90c58e3407" />

---
---

### Project 1 - VPC Resource Provsioning Successful with the necessary state and lock file

```
Releasing state lock. This may take a few moments...

Apply complete! Resources: 25 added, 0 changed, 0 destroyed.

Outputs:

database_subnets = [
  "subnet-07cac9dc8b0b26998",
  "subnet-0e440182ac337050c",
]
nat_public_ips = tolist([
  "54.187.94.143",
])
private_subnets = [
  "subnet-05aa502bdd7b36807",
  "subnet-026f20e3ccf7c423f",
]
public_subnets = [
  "subnet-01964bf196d48e9e8",
  "subnet-0ad3508ffc49ae8fe",
]
vpc_azs = tolist([
  "us-west-2a",
  "us-west-2b",
])
vpc_cidr_block = "10.0.0.0/16"
vpc_id = "vpc-022670a9c585a6234"
```
---

<img width="955" height="758" alt="image" src="https://github.com/user-attachments/assets/7f8ab9a0-bfc8-47e4-9179-7434283f82fa" />

---
---

## Creation of Project 2

- Copied all the files from the ASG project [12-ASG-with-Launch-Template-with-ALB-Route53](/12-ASG-with-Launch-Template-with-ALB-Route53/)

### Project 2 initialization

---

<img width="963" height="915" alt="image" src="https://github.com/user-attachments/assets/f0aa98e9-cf48-45ad-aaca-ce223d659861" />

---
























