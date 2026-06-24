### Copied all the files from our VPC module [vpc-module](/04-vpc-module/2-standardised-module/) 

  - There is a slight addition to the `versions.tf` file - we need to add the backend block

#### But before doing anything else, we need to create the s3 file and a key into which the state of our terraform would be stored 

### Create S3 Bucket

  - Go to Services -> S3 -> Create Bucket  
  - Bucket name: <bucket-name>
  - Region: <your-region>
  - Bucket settings for Block Public Access: leave to defaults
  - Bucket Versioning: Enable  --> Very Important for the state file
  - Rest all leave to defaults
  - Click on Create Bucket
  ** Below steps are optional as the _key_ argument can create it anyways**
  - Create Folder
  - Folder Name: dev
  - Click on Create Folder
  - Create Folder
  - Folder Name: devops/project1-vpc  --> any path of your choice
  - Click on Create Folder

### Deprecation of the dynamo_table argument

  - `dynamo-table` argument and any other argument related to dynamo_db for state locking is deprecated
  - `use_lockfile` argument is used now for a single place for storing the state file and the lock
  - If we don't mention the `.tfstate` file in the `key` argument:
      - `use_lockfile` argument creates a `.lock` file on its own and stores the state and manages the lock

  - So the backend block becomes:

```hcl
terraform {
  required_version = "~> 1.15.4"
  required_providers {
    aws = {
      source = "hashicorp/aws/terraform.tfstate"   # we can use key = "devops/project1-vpc
      version = "~> 6.47"
    }
  }

  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "my-s3-backend-for-aws-vpc"
    key    = "devops/project1-vpc"
    region = "us-west-2"

    # For State Locking
    # dynamodb_table = "project1-devops-vpc"  --> Deprecated
    use_lockfile = true  
  }
}
```

---

### Initialization of the backed:

**We can see the changes in our backend configurations notification:**

---

<img width="783" height="285" alt="image" src="https://github.com/user-attachments/assets/a98a8342-1c34-46e6-abe0-57a0532dc1e0" />

---
---

### Resources Provisioned Successfully

```
module.vpc.aws_route.private_nat_gateway[0]: Creation complete after 3s [id=r-rtb-0dec25d2bdcc74ba31080289494]
Releasing state lock. This may take a few moments...

Apply complete! Resources: 25 added, 0 changed, 0 destroyed.

Outputs:

database_subnets = [
  "subnet-04efe272c268acb81",
  "subnet-0167c3f973e4950d6",
]
nat_public_ips = tolist([
  "44.227.5.87",
])
private_subnets = [
  "subnet-011377a5f830b2610",
  "subnet-084b6006e072b4817",
]
public_subnets = [
  "subnet-0285e3eec00ef2369",
  "subnet-08d93c98179688dad",
]
vpc_azs = tolist([
  "us-west-2a",
  "us-west-2b",
])
vpc_cidr_block = "10.0.0.0/16"
vpc_id = "vpc-0d4dce70f378eedbb"
```

**We can see our state file**
  - We need to enable versioning inside the bucket to see it
---

<img width="1551" height="634" alt="image" src="https://github.com/user-attachments/assets/4fe770bd-953f-4c8e-abc7-b25b35fd1847" />

---
---

**After the completion of destruction of the resources, we see:**

```
Releasing state lock. This may take a few moments...

Destroy complete! Resources: 25 destroyed.
```

**And in we can see the changes to our state file in the s3:**

---

<img width="1614" height="776" alt="image" src="https://github.com/user-attachments/assets/a2fe25df-89b5-4a95-b24b-30b2f14aef60" />

---
---

### We also tried configuring the key argument without the .tfstate file

```hcl
backend "s3" {
    bucket = "my-s3-backend-for-aws-vpc"
    key    = "devops/project1-vpc"
    region = "us-west-2"
    use_lockfile = true  
  }
```

**And we can see the `.tflock` getting generated which acts as both the state file and the lock file:

---

<img width="1620" height="575" alt="image" src="https://github.com/user-attachments/assets/fa0063fb-12a8-43d1-be09-fa664425892a" />

---
---













