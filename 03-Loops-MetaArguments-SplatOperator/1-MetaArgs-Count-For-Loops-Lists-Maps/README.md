Count created the 2 instances:

---

<img width="898" height="780" alt="image" src="https://github.com/user-attachments/assets/1798632a-99e3-4c21-92ee-789833e976f0" />

---

These Output Blocks:

```hcl
# Terraform Output Values 

# 1. For Loop with List
output "for_output_list" {
  description = "For loop with List"
  value = [for instance in aws_instance.my_ec2: instance.public_dns]
}

# 2. For Loop with Map
output "for_output_map1" {
  description = "For loop with Map"
  value = {for instance in aws_instance.my_ec2: instance.id => instance.public_dns}
}

# 3. For Loop with Map Advanced
output "for_output_map2" {
    description = "For loop with Map - Advanced"
    value = {for i, instance in aws_instance.my_ec2: i => instance.public_dns}
}

# 4. Out for Splat Operator - Returns List
output "splat_output" {
  description = "Splat Operator"
  value = aws_instance.my_ec2[*].public_dns
}
```

Gave these outputs:

---

<img width="747" height="440" alt="image" src="https://github.com/user-attachments/assets/4393211a-9e13-45f1-b849-0f125f4be7d3" />

---

We have added a few more:

```hcl
# Terraform Output Values 

# 1. For Loop with List
output "for_output_list" {
  description = "For loop with List"
  value = [for instance in aws_instance.my_ec2: instance.public_dns]
}

# 2. For Loop with Map
output "for_output_map1" {
  description = "For loop with Map"
  value = {for instance in aws_instance.my_ec2: instance.id => instance.public_dns}
}

output "for_output_map2" {
  description = "For loop with Map"
  value = {for instance in aws_instance.my_ec2: instance.id => instance.private_dns}
}

output "for_output_map3" {
  description = "For loop with Map"
  value = {for instance in aws_instance.my_ec2: instance.id => instance.public_ip}
}

output "for_output_map4" {
  description = "For loop with Map"
  value = {for instance in aws_instance.my_ec2: instance.id => instance.private_ip}
}

# 3. For Loop with Map Advanced
output "for_output_map_adv" {
    description = "For loop with Map - Advanced"
    value = {for i, instance in aws_instance.my_ec2: i => instance.public_dns}
}

# 4. Out for Splat Operator - Returns List
output "splat_output1" {
  description = "Splat Operator"
  value = aws_instance.my_ec2[*].public_dns
}

output "splat_output2" {
  description = "Splat Operator"
  value = aws_instance.my_ec2[*].private_dns
}

output "splat_output3" {
  description = "Splat Operator"
  value = aws_instance.my_ec2[*].public_ip
}

output "splat_output4" {
  description = "Splat Operator"
  value = aws_instance.my_ec2[*].private_ip
}
```

Which gives:

---

<img width="766" height="853" alt="image" src="https://github.com/user-attachments/assets/f002b775-e6f2-4b99-aac1-c9672797823c" />

---

***Fun Fact***: I have run `terraform destroy` and then `terraform plan and apply` again to get the above output to the entire output in a sequence, if not done like this and
if had just run terraform plan and apply, we would have seen only the changes in the new plan.

























