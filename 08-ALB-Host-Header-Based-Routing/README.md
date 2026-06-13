## Resource Provisioning Successful

#### Shown most of the outputs (target_groups outputs are skipped)
```
Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

acm_certificate_arn = "arn:aws:acm:us-west-2:408945636231:certificate/e45f4da1-cd69-484b-a114-5b07eeaa1bf4"
acm_certificate_status = "ISSUED"
alb_sg_group_id = "sg-04140d735fc6d7803"
alb_sg_group_name = "alb-security-group-20260613052431513900000009"
alb_sg_group_vpc_id = "vpc-075a19e7b14561210"
arn = "arn:aws:elasticloadbalancing:us-west-2:408945636231:loadbalancer/app/Terraform-Cloud-DevOps-alb/303a9d68fe2b315e"
arn_suffix = "app/Terraform-Cloud-DevOps-alb/303a9d68fe2b315e"
database_subnets = [
  "subnet-06a15fd94cdad5ddb",
  "subnet-05d4a6093b4f4fcad",
]
distinct_domain_names = tolist([
  "vinodnayan.academy",
])
dns_name = "Terraform-Cloud-DevOps-alb-87362200.us-west-2.elb.amazonaws.com"
ec2_bastion_instance_id = "i-01f53d4e9a453d729"
ec2_bastion_public_ip = "44.239.22.115"
ec2_private_instance_ids_1 = [
  "i-0c6a950189aefb63a",
  "i-068cd5d074e6b4aa3",
]
ec2_private_instance_ids_2 = [
  "i-0d9c381954f67e21b",
  "i-021ba89881d2967f3",
]
ec2_private_ip_1 = [
  "10.0.111.145",
  "10.0.112.187",
]
ec2_private_ip_2 = [
  "10.0.111.155",
  "10.0.112.206",
]
elastic_ip = "44.239.22.115"
id = "arn:aws:elasticloadbalancing:us-west-2:408945636231:loadbalancer/app/Terraform-Cloud-DevOps-alb/303a9d68fe2b315e"
listener_rules = <sensitive>
listeners = <sensitive>
mydamain_zone_id = "Z004567121HZWIXXGFNV6"
mydomain_name = "vinodnayan.academy"
mydomain_name_servers = tolist([
  "ns-1866.awsdns-41.co.uk",
  "ns-884.awsdns-46.net",
  "ns-1192.awsdns-21.org",
  "ns-343.awsdns-42.com",
])
nat_public_ips = tolist([
  "52.41.161.203",
])
private_bastion_sg_group_id = "sg-003d79c5e51233976"
private_sg_group_name = "private-security-group-20260613052430651700000004"
private_sg_group_vpc_id = "vpc-075a19e7b14561210"
private_sg_owner_id = "408945636231"
private_subnets = [
  "subnet-04879634a74e7aaba",
  "subnet-08970fa39280498a9",
]
public_bastion_sg_group_id = "sg-0f28ab07437e1d29f"
public_bastion_sg_group_name = "public-bastion-security-group-20260613052430669300000005"
public_bastion_sg_group_vpc_id = "vpc-075a19e7b14561210"
public_bastion_sg_owner_id = "408945636231"
public_subnets = [
  "subnet-0a204b00159ae50c9",
  "subnet-0b5fe9349231f8a83",
]
security_group_arn = "arn:aws:ec2:us-west-2:408945636231:security-group/sg-01d8248b651b0ceff"
security_group_id = "sg-01d8248b651b0ceff"
```

---

## New Records in the Route 53 Hosted Zone added:

---

<img width="1706" height="853" alt="image" src="https://github.com/user-attachments/assets/5c767d87-98ef-40fa-af8f-012ddcb22e2a" />

---

## ACM similar to the path based:

---

<img width="1603" height="647" alt="image" src="https://github.com/user-attachments/assets/1da3a92a-2874-428b-90f1-a91e0a4ff1b1" />

---

## Load Balancer Resource Map, Listerners and Rules

---

<img width="1430" height="854" alt="image" src="https://github.com/user-attachments/assets/cbfef476-c8c7-423a-83d4-4319810fd9e0" />

---
---

<img width="1455" height="460" alt="Screenshot 2026-06-13 110938" src="https://github.com/user-attachments/assets/0d478226-3f7a-47f4-ab54-d14f158227c3" />

---
---

<img width="1581" height="877" alt="image" src="https://github.com/user-attachments/assets/94790af7-9ca4-4729-98a6-3e60290d2bbd" />

---

## Instances:

---

<img width="1151" height="281" alt="image" src="https://github.com/user-attachments/assets/eb4055d6-3f24-4af1-8fb6-39891d969a0a" />

---

# Host Header Based Routing Succesful

https://github.com/user-attachments/assets/b9c5688e-606c-4a18-a48d-68fb94612927

---
















