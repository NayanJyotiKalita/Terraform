We have the version and data files as such:

```hcl
terraform {
  required_version = "~> 1.15.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

```hcl
# Datasource
data "aws_ec2_instance_type_offerings" "available_types_1" {
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }

  filter {
    name   = "location"
    values = ["us-east-1b"]
  }

  location_type = "availability-zone"
}

output "output_1" {
  value = data.aws_ec2_instance_type_offerings.available_types_1.instance_types
}
```

And in `terraform plan`, we see that our `us-east-1a` has the `t3.micro` instance available in it:

---

<img width="875" height="682" alt="image" src="https://github.com/user-attachments/assets/e6dc2a19-2735-4489-8afa-b530574f4c03" />

---

And as soon as we change the AZ location to `us-east-1e`, we see an empty set:

---

<img width="911" height="705" alt="image" src="https://github.com/user-attachments/assets/704a6475-1447-41cd-988a-887ffd3f30bc" />

---

Now we move step ahead and make some modifications:

```hcl
# Datasource
data "aws_ec2_instance_type_offerings" "available_types_2" {
  for_each = toset([ "us-east-1a", "us-east-1b", "us-east-1e" ])
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }

  filter {
    name   = "location"
    values = [each.key]
  }

  location_type = "availability-zone"
}

#Output-1
# Important Note: Once for_each is set, its attributes must be accessed on specific instances

output "output_i3_1" {
  value = toset([for i in data.aws_ec2_instance_type_offerings.available_types_2: i.instance_types])
}
```

Here we observe that we are shown only one `t3.micro` instance would be added and only empty list which means that the `us-east-1e` would be blank. But a thought might
come that there should have been two `t3.micro` addition - but the catch is the `toset()` function that we are using - it removes duplicates

---

<img width="317" height="203" alt="image" src="https://github.com/user-attachments/assets/8fc5dce3-fc9f-4528-9ec5-0413815a8c3a" />

---

So, to avoid confusion and make it took precise as to which AZ has which instance type, we map the AZ to its result:

```hcl
#Output-1
# Important Note: Once for_each is set, its attributes must be accessed on specific instances

output "output_i3_1" {
  value = toset([for i in data.aws_ec2_instance_type_offerings.available_types_2: i.instance_types])
}

#Output-2
# Create a Map with Key as Availability Zone and value as Instance Type

output "output_i3_2" {
  value = {
    for i, instance in data.aws_ec2_instance_type_offerings.available_types_2: i => instance.instance_types
  }
}
```

---

<img width="319" height="391" alt="image" src="https://github.com/user-attachments/assets/a55a774d-a6fe-4b6c-a756-40115164a758" />

---

Then move one step further to get clean outputs

Based on the below `.tf` file, we keep on adding different outputs to get the outputs the way we want

```hcl
# Get List of Availability Zones in a Specific Region
# Region is set in c1-versions.tf in Provider Block
# Datasource-1
data "aws_availability_zones" "my_azs" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Check if that respective Instance Type is supported in that Specific Region in list of availability Zones
# Get the List of Availability Zones in a Particular region where that respective Instance Type is supported
# Datasource-2
data "aws_ec2_instance_type_offerings" "available_types_3" {
  for_each = toset(data.aws_availability_zones.my_azs.names)
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }

  filter {
    name   = "location"
    values = [each.key]
  }

  location_type = "availability-zone"
}
```
```hcl
# Output-1
# Basic Output: All Availability Zones mapped to Supported Instance Types
output "output_i4_1"{
    value = {
        for i, instance in data.aws_ec2_instance_type_offerings.available_types_3: i => instance.instance_types
    }
}
```

---

<img width="285" height="396" alt="image" src="https://github.com/user-attachments/assets/0e6edec3-2312-415f-bb86-c63af6255140" />

---

Now we exclude the AZs which don't support our instance type:

```hcl
# Output-2
# Filtered Output: Exclude Unsupported Availability Zones
output "output_i4_2" {
  value = {
    for i, instance in data.aws_ec2_instance_type_offerings.available_types_3:
    i => instance.instance_types if length(instance.instance_types) != 0
  }
}
```

---

<img width="290" height="370" alt="image" src="https://github.com/user-attachments/assets/7e7351cd-0176-4030-90ae-be33a460bdc7" />

---

Now we list only the AZs as keys:

```hcl
# Output-3
# Filtered Output: with Keys Function - Which gets keys from a Map
# This will return the list of availability zones supported for a instance type
output "output_i4_3" {
  value = keys({
    for i, instance in data.aws_ec2_instance_type_offerings.available_types_3: 
    i => instance.instance_types if length(instance.instance_types) != 0
  })
}
```

---


<img width="250" height="162" alt="image" src="https://github.com/user-attachments/assets/364dc690-378b-418a-9a92-f1fb6318aede" />

---

Finally, we go one step ahead just because we can 😜

```hcl
# # Output-4 (additional)
# Filtered Output: As the output is list now, get the first item from list
output "output_i4_4" {
  value = keys({
    for i, instance in data.aws_ec2_instance_type_offerings.available_types_3:
    i => instance.instance_types if length(instance.instance_types) != 0})[0]
}
```

---

<img width="298" height="38" alt="image" src="https://github.com/user-attachments/assets/943cbb72-c72c-4871-b9bc-893028bbc797" />

---

So our final output of all the output blocks looks something like this (it shows how we progressed):

```
Changes to Outputs:
  + output_i2   = []
  + output_i3_1 = [
      + [
          + "t3.micro",
        ],
      + [],
    ]
  + output_i3_2 = {
      + us-east-1a = [
          + "t3.micro",
        ]
      + us-east-1b = [
          + "t3.micro",
        ]
      + us-east-1e = []
    }
  + output_i4_1 = {
      + us-east-1a = [
          + "t3.micro",
        ]
      + us-east-1b = [
          + "t3.micro",
        ]
      + us-east-1c = [
          + "t3.micro",
        ]
      + us-east-1d = [
          + "t3.micro",
        ]
      + us-east-1e = []
      + us-east-1f = [
          + "t3.micro",
        ]
    }
  + output_i4_2 = {
      + us-east-1a = [
          + "t3.micro",
        ]
      + us-east-1b = [
          + "t3.micro",
        ]
      + us-east-1c = [
          + "t3.micro",
        ]
      + us-east-1d = [
          + "t3.micro",
        ]
      + us-east-1f = [
          + "t3.micro",
        ]
    }
  + output_i4_3 = [
      + "us-east-1a",
      + "us-east-1b",
      + "us-east-1c",
      + "us-east-1d",
      + "us-east-1f",
    ]
  + output_i4_4 = "us-east-1a"
```














