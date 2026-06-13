
Error Alert: Got this error while planning:

```
│ Error: creating ELBv2 Listener Rule: operation error Elastic Load Balancing v2: CreateRule, https response error StatusCode: 400, RequestID: 93958e3c-cd02-4592-8be4-b66f86db6727, api error ValidationError: Condition value 'my-app-1' contains a character that is not valid
│ 
│   with module.alb.aws_lb_listener_rule.this["my-https-listener/app1-rule"],
│   on .terraform/modules/alb/main.tf line 331, in resource "aws_lb_listener_rule" "this":
│  331: resource "aws_lb_listener_rule" "this" {
│ 
╵
╷
│ Error: creating ELBv2 Listener Rule: operation error Elastic Load Balancing v2: CreateRule, https response error StatusCode: 400, RequestID: 6c80442d-b8bd-4a30-b109-928dec42b577, api error ValidationError: Condition value 'my-app-2' contains a character that is not valid
│ 
│   with module.alb.aws_lb_listener_rule.this["my-https-listener/app2-rule"],
│   on .terraform/modules/alb/main.tf line 331, in resource "aws_lb_listener_rule" "this":
│  331: resource "aws_lb_listener_rule" "this" {
```
#### Reason:
We Got the above error because in the app1-rule and app2-rule, we added a value which is invalid
```
app1-rule = {
          priority = 1
          actions = [{
            weighted_forward = {
              target_groups = [
                  {
                  target_group_key = "mytg1"
                  weight           = 1
                }
              ]
              stickiness = {
                enabled  = true
                duration = 3600
              }
            }
          }]
          conditions = [
            {
              host_header = {          --> because of this, as it expects the values to be some domains, but here we want implement custom http header redirection
                http_header_name = "custom-header"
                values = ["app-1", "app1", "my-app-1", "my-app1"] 
              }
            }
          ]
        }
```

## Finally, our resources got provisioned

#### Keept the 
```
Apply complete! Resources: 3 added, 0 changed, 1 destroyed.

Outputs:

acm_certificate_arn = "arn:aws:acm:us-west-2:408945636231:certificate/1bf2f6aa-3e3d-4690-9e9c-782b683d9654"
acm_certificate_status = "ISSUED"
alb_sg_group_id = "sg-0b4a4f201223d89cd"
alb_sg_group_name = "alb-security-group-20260613071638800400000004"
alb_sg_group_vpc_id = "vpc-013d4b854927b9206"
alb_sg_owner_id = "408945636231"
arn = "arn:aws:elasticloadbalancing:us-west-2:408945636231:loadbalancer/app/AI-Cloud-alb/2b73d78951c4d19e"
arn_suffix = "app/AI-Cloud-alb/2b73d78951c4d19e"
database_subnets = [
  "subnet-05adba2b947726b98",
  "subnet-0bba2af35bd842cfe",
]
distinct_domain_names = tolist([
  "vinodnayan.academy",
])
dns_name = "AI-Cloud-alb-505226671.us-west-2.elb.amazonaws.com"
ec2_bastion_instance_id = "i-0122a28a38749aab7"
ec2_bastion_public_ip = "52.88.78.41"
ec2_private_instance_ids_1 = [
  "i-03ba7a4b146c1eaf9",
  "i-0c79dc749d32b0716",
]
ec2_private_instance_ids_2 = [
  "i-05dfbd49f81b2a816",
  "i-030d821d44d275607",
]
ec2_private_ip_1 = [
  "10.0.111.181",
  "10.0.112.90",
]
ec2_private_ip_2 = [
  "10.0.111.218",
  "10.0.112.7",
]
elastic_ip = "52.88.78.41"
id = "arn:aws:elasticloadbalancing:us-west-2:408945636231:loadbalancer/app/AI-Cloud-alb/2b73d78951c4d19e"
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
  "35.83.136.67",
])
```

## Route 53 Hosted Zone Records

---

<img width="1496" height="796" alt="image" src="https://github.com/user-attachments/assets/42e5db76-b842-45e5-a742-c4619a8da097" />

---
---

## ACM Issued

---

<img width="1760" height="641" alt="image" src="https://github.com/user-attachments/assets/f9884294-ac6d-4934-a2ad-114a4761e1f6" />

---
---

## Load Balancer Resource Maps, Listeners and Rules

---

<img width="1575" height="868" alt="image" src="https://github.com/user-attachments/assets/4c6c15a9-7c85-4f74-aa58-3715c1f07840" />

---
---

<img width="1559" height="873" alt="image" src="https://github.com/user-attachments/assets/eb5c50e2-378d-45e4-8b13-6847e82c92ab" />

---
---

# Custom HTTP Header based Routing

---

<img width="1828" height="572" alt="image" src="https://github.com/user-attachments/assets/0f9caf44-4fcd-4581-bc81-b5a7910be393" />

---

## HTTP Header based routing is different than Host Based Routing (Be Mindful of this Distinction)
  - Host Header Routing routes traffic based on the domain/subdomain requested by the user, whereas HTTP Header Routing routes traffic based on the value of a specific HTTP header sent in the request.
  - Host header routing typically relies on DNS records pointing to the same ALB, while HTTP header routing requires the client to explicitly send the matching header.

**e.g.** if we try to put the Custom http header instead of the host name, we would not be able to access:
---

<img width="829" height="481" alt="image" src="https://github.com/user-attachments/assets/d870b799-b6ae-4134-bdd4-950a81dc473f" />

---
or

```bash
chucky@Dell:~/Terraform/09-ALB-HTTPHeader-CustomHeader-QueryString-Redirects$ nslookup app-1.vinodnayan.academy
Server:         10.255.255.254
Address:        10.255.255.254#53

** server can't find app-1.vinodnayan.academy: NXDOMAIN
```
---
---

# Query String and Host Header Redirection

---

https://github.com/user-attachments/assets/94a98c41-8e4d-4b71-88a1-3cf3dbc76e1e

---

























