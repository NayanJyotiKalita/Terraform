# Setting an Application Load Balancer (ALB) with Basic Configurations

We have built on top of the previous configurations, just added a few file for the ALB

## Security Group 

`i5-03-sg-loadbalancersg.tf`
```hcl
module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name          = "alb-security-group"
  description   = "Security Group with HTTP open for entire Internet"
  vpc_id        = module.vpc.vpc_id 

  # Ingress Rules & CIDR Blocks for ssh and http for internal traffic
  ingress_rules            = ["http-80-tcp"]
  ingress_cidr_blocks      = ["0.0.0.0/0"]

  # Egress Rule - all-all open
  egress_rules             = ["all-all"]
  tags = local.common_tags
}
```

Added a few output blocks in the `i5-04-sg-outputs.tf` file:

```hcl
# Loadbalancer Security Group Outputs
## alb_sg_id
output "alb_sg_group_id" {
  description = "The ID of the security group"
  value = module.loadbalancer_sg.security_group_id
}

## alb_sg_group_vpc_id
output "alb_sg_group_vpc_id" {
  description = "VPC ID"
  value = module.loadbalancer_sg.security_group_vpc_id
}

## alb_sg_group_name
output "alb_sg_group_name" {
  description = "The name of the security group"
  value = module.loadbalancer_sg.security_group_name
}

# alb_sg_owner_id
output "alb_sg_owner_id" {
  description = "The owner id of the security group"
  value = module.loadbalancer_sg.security_group_owner_id
}
```

---

## ALB Module

`i10-01-ALB.tf`
```hcl
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.0"

  name    = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = [module.loadbalancer_sg.security_group_id]

  # For example only
  enable_deletion_protection = false

  # Listeners
  listeners = {
    # Listener: my-http-listener
    my-http-listener = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "mytg"
      }
    } # End of my-http-listener
  }  # End of listeners block
  
  # Target Groups
  target_groups = {
    mytg = {
      # VERY IMPORTANT: We will create aws_lb_target_group_attachment resource separately when we use create_attachment = false
      create_attachment = false
      name_prefix                       = "mytg-"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      protocol_version = "HTTP1"

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      } # End of health_check Block
      tags = local.common_tags  # target_group tags
    } # End of taget_groups Block
  }
  tags = local.common_tags  # ALB Tags
}

resource "aws_lb_target_group_attachment" "mytg" {
  for_each = {for i, j in module.ec2_private: i => j}   # module.ec2_private redirects to the entire private ec2 details, i redirects to the indices (i.e. 0 and 1 in our case) and j redirects to the instance details
  target_group_arn = module.alb.target_groups["mytg"].arn
  target_id        = each.value.id
  port             = 80
}

## i = indices of ec2_instance e.g - 0 and 1
## j = ec2_instance_details

# Output block to visualize the i and j
output "i_j_private_outputs" {
  value = {for instance_idx, instance_details in module.ec2_private: instance_idx => instance_details}
}
```

### Also added a few output blocks for the ALB here [i10-02-ALB-outputs.tf](/06-ALB-Basic/i10-02-ALB-outputs.tf) 

---

## Time to Initialize, Plan and Apply:

```
Apply complete! Resources: 55 added, 0 changed, 0 destroyed.

Outputs:

alb_sg_group_id = "sg-0966d26c537d42397"
alb_sg_group_name = "alb-security-group-20260602070623476000000008"
alb_sg_group_vpc_id = "vpc-0884835f551224b26"
alb_sg_owner_id = "202512444928"
arn = "arn:aws:elasticloadbalancing:us-west-2:202512444928:loadbalancer/app/HR-stage-alb/a229a515d25dc639"
arn_suffix = "app/HR-stage-alb/a229a515d25dc639"
database_subnets = [
  "subnet-016bed2fe4dae1d6c",
  "subnet-02cd36739e94374ab",
]
dns_name = "HR-stage-alb-1777898336.us-west-2.elb.amazonaws.com"
ec2_bastion_instance_id = "i-06984b7273d103162"
ec2_bastion_public_ip = ""
ec2_private_instance_ids = [
  "i-0e0580c05d7659449",
  "i-04bf537296c43f28b",
]
ec2_private_ip = [
  "10.0.111.115",
  "10.0.112.178",
]
elastic_ip = "44.254.96.65"
i_j_private_outputs = {                           --> is the output of the for loop in the map that we configured at the end of our alb module
  "0" = {
    "ami" = "ami-02e5e470f9b32980d"
    "arn" = "arn:aws:ec2:us-west-2:202512444928:instance/i-0e0580c05d7659449"
    "availability_zone" = "us-west-2a"
    "capacity_reservation_specification" = tolist([
      {
        "capacity_reservation_preference" = "open"
        "capacity_reservation_target" = tolist([])
      },
    ])
    "ebs_block_device" = toset([])
    "ebs_volumes" = {}
    "ephemeral_block_device" = toset([])
    "iam_instance_profile_arn" = null
    "iam_instance_profile_id" = null
    "iam_instance_profile_unique" = null
    "iam_role_arn" = null
    "iam_role_name" = null
    "iam_role_unique_id" = null
    "id" = "i-0e0580c05d7659449"
    "instance_state" = "running"
    "ipv6_addresses" = tolist([])
  }
  "1" = {
    "ami" = "ami-02e5e470f9b32980d"
    "arn" = "arn:aws:ec2:us-west-2:202512444928:instance/i-04bf537296c43f28b"
    "availability_zone" = "us-west-2b"
    "capacity_reservation_specification" = tolist([
      {
        "capacity_reservation_preference" = "open"
        "capacity_reservation_target" = tolist([])
      },
    ])
    "ebs_block_device" = toset([])
    "ebs_volumes" = {}
    "ephemeral_block_device" = toset([])
    "iam_instance_profile_arn" = null
    "iam_instance_profile_id" = null
    "iam_instance_profile_unique" = null
    "iam_role_arn" = null
    "iam_role_name" = null
    "iam_role_unique_id" = null
    "id" = "i-04bf537296c43f28b"
    "instance_state" = "running"
    "ipv6_addresses" = tolist([])
}
id = "arn:aws:elasticloadbalancing:us-west-2:202512444928:loadbalancer/app/HR-stage-alb/a229a515d25dc639"
listener_rules = <sensitive>
listeners = <sensitive>
nat_public_ips = tolist([
  "44.232.200.205",
])
private_bastion_sg_group_id = "sg-07f2e88ba15d2e3ce"
private_sg_group_name = "private-security-group-20260602070622987200000005"
private_sg_group_vpc_id = "vpc-0884835f551224b26"
private_sg_owner_id = "202512444928"
private_subnets = [
  "subnet-0bb2375779a642813",
  "subnet-0c87efaa2248aa35e",
]
public_bastion_sg_group_id = "sg-0d6591461da885bc9"
public_bastion_sg_group_name = "public-bastion-security-group-20260602070623374300000007"
public_bastion_sg_group_vpc_id = "vpc-0884835f551224b26"
public_bastion_sg_owner_id = "202512444928"
public_subnets = [
  "subnet-0c133d57be7afc522",
  "subnet-0087357f3b8b18035",
]
security_group_arn = "arn:aws:ec2:us-west-2:202512444928:security-group/sg-0622ae1b84bc03b76"
security_group_id = "sg-0622ae1b84bc03b76"
vpc_azs = tolist([
  "us-west-2a",
  "us-west-2b",
])
vpc_cidr_block = "10.0.0.0/16"
vpc_id = "vpc-0884835f551224b26"
zone_id = "Z1H1FL5HABSF5"
```


# We can see our Load Balancer and its Target Group 
---

<img width="1638" height="831" alt="image" src="https://github.com/user-attachments/assets/52623e62-5666-48f1-87a0-c1c8663fee45" />

---

<img width="1737" height="632" alt="image" src="https://github.com/user-attachments/assets/71e9f811-f148-40cb-80e8-1ff069511792" />

---

### We can access our webserver, which running in the private subnet, from external world using the DNS of the ALB:

---

<img width="1060" height="99" alt="image" src="https://github.com/user-attachments/assets/1fd32140-078e-4e4a-859b-d14eead1285a" />

---

<img width="1131" height="116" alt="image" src="https://github.com/user-attachments/assets/08b42d5d-50af-4f74-889e-8f744804b2da" />

---

### We can also see the output coming from the `local-exec provisioner`:

---

<img width="984" height="130" alt="image" src="https://github.com/user-attachments/assets/ec47766c-5964-49c7-96a9-06732e0da101" />

---

In the above picture, we can see there are three instances' details which is because I created and destroyed the resources thrice.

---

###
---
Right now we have enabled the traffic coming from port 80 from the outside world to access our Load Balancer, we want to configure the traffic coming from, let's say, port 81, let's configure that:

Right now, we cannot access from port 81:

---

<img width="824" height="684" alt="image" src="https://github.com/user-attachments/assets/bbd2e6ec-864f-4004-b668-1c43bb8b2d41" />

---

### Updating the ALB Security Group, and the Listener Block in the ALB Module

We update the Security Group of the Load Balancer:

```hcl
module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name          = "alb-security-group"
  description   = "Security Group with HTTP open for entire Internet"
  vpc_id        = module.vpc.vpc_id 

  # Ingress Rules & CIDR Blocks for ssh and http for internal traffic
  ingress_rules            = ["http-80-tcp"]
  ingress_cidr_blocks      = ["0.0.0.0/0"]

  # Egress Rule - all-all open
  egress_rules             = ["all-all"]
  tags = local.common_tags

  ingress_with_cidr_blocks = [
    {
      from_port   = 81
      to_port     = 81
      protocol    = 6
      description = "Allow Port 81 from internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
```

And the Listener block in the ALB module:

```hcl
 # Listeners
  listeners = {
    # Listener: my-http-listener
    my-http-listener = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "mytg"
      }
    } # End of my-http-listener

    # Listener: my-http-81-listener
    my-http-listener = {
      port     = 81
      protocol = "HTTP"
      forward = {
        target_group_key = "mytg"
      }
    } # End of my-http-81-listener

  }  # End of listeners block
  ```

Applied changes, and now let's try to access using the port 81:

---

<img width="1068" height="101" alt="image" src="https://github.com/user-attachments/assets/238bc3f8-c915-4f3a-bade-8bd8f70b1b70" />

---

## Cleanup

```bash
terraform destroy -auto-approve
rm -rf .terraform*
rm -rf terraform.tfstate*
```









