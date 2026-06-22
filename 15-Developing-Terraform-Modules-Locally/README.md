# Developing Terraform Modules Locally

- Once we copy the module files into our manifests and change the source rediction in our `vpc.tf`, the initialization commands acts differently
- It doesn't download the files from the Terraform Registry

---

<img width="937" height="364" alt="Screenshot 2026-06-22 163531" src="https://github.com/user-attachments/assets/3048e856-3eab-4854-8d80-b04dcb1af22e" />

---
---

### And we get the same results:

```
Apply complete! Resources: 30 added, 0 changed, 0 destroyed.

Outputs:

database_subnets = [
  "subnet-054cf427c16477672",
  "subnet-0ea88f72b0ca30330",
]
nat_public_ips = tolist([
  "34.218.168.163",
  "34.213.148.56",
])
private_subnets = [
  "subnet-0fbc173210b5d16ea",
  "subnet-0ed1bc553488b71b6",
]
public_subnets = [
  "subnet-087da197d9037bcec",
  "subnet-0d8f74ed2b8e31293",
]
vpc_azs = tolist([
  "us-west-2a",
  "us-west-2b",
])
vpc_cidr_block = "10.0.0.0/16"
vpc_id = "vpc-01d07821fd5f21af3"
```

---

<img width="1581" height="562" alt="image" src="https://github.com/user-attachments/assets/5c805cd3-f66f-42f9-933a-5d35879fa2e7" />
