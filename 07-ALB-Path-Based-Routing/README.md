## Successfully Provisioned the Resources

#### Added only a few outputs:

```
Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

acm_certificate_arn = "arn:aws:acm:us-west-2:408945636231:certificate/02e7fa04-7039-48d4-a560-9311c83ac969"
acm_certificate_status = "ISSUED"
alb_sg_group_id = "sg-0eb7654df12896d1a"
alb_sg_group_name = "alb-security-group-20260613023049443000000007"
alb_sg_group_vpc_id = "vpc-0b17191e9c6cfff27"
arn_suffix = "app/HR-stage-alb/ff0fa6e3bcf8b14a"
database_subnets = [
  "subnet-0150254d4b55e32e6",
  "subnet-011969f0241ac9afe",
]
distinct_domain_names = tolist([
  "vinodnayan.academy",
])
dns_name = "HR-stage-alb-1032938283.us-west-2.elb.amazonaws.com"
ec2_bastion_instance_id = "i-0c9783d159a8eb8e0"
ec2_bastion_public_ip = ""
ec2_private_instance_ids_1 = [
  "i-091ded4cffbb735f9",
  "i-0797dce1cc0447a17",
]
ec2_private_instance_ids_2 = [
  "i-0fa5eea3654c066b8",
  "i-076e0bf97195fad23",
]
ec2_private_ip_1 = [
  "10.0.111.33",
  "10.0.112.202",
]
ec2_private_ip_2 = [
  "10.0.111.229",
  "10.0.112.170",
]
elastic_ip = "184.33.60.130"
id = "arn:aws:elasticloadbalancing:us-west-2:408945636231:loadbalancer/app/HR-stage-alb/ff0fa6e3bcf8b14a"
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
  "54.149.90.162",
])
```



Route 53 DNS Registration for the corresponding block:

```
resource "aws_route53_record" "my_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = "apps.vinodnayan.academy"
  type    = "A"
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}
```

We can see the same in the Hosted Zone created:

---

<img width="1533" height="858" alt="image" src="https://github.com/user-attachments/assets/5395fc17-c11e-484a-b062-33a05f513318" />

---

## Load Balancers - Routes, Listerners, Rules

---

<img width="1430" height="814" alt="image" src="https://github.com/user-attachments/assets/7bb641dc-6da5-4923-b858-e1891298b9ed" />

---

<img width="1605" height="812" alt="image" src="https://github.com/user-attachments/assets/07abcef9-9269-43b0-84c7-41b38b63f233" />

---

<img width="1613" height="880" alt="image" src="https://github.com/user-attachments/assets/c7d8ab25-9a66-4a38-9161-cb54597d37ae" />

---


## ACM Created 

---

<img width="1782" height="643" alt="image" src="https://github.com/user-attachments/assets/8aa6ee2d-856a-4e32-88fc-ba5f16f86516" />

---

## Path Based Routing Successful

---

https://github.com/user-attachments/assets/9a99948f-95b6-419b-9896-35b1364de36c

---














