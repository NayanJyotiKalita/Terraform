# Provisioned my first EC2 Instance using Terraform

<img width="1716" height="594" alt="Image" src="https://github.com/user-attachments/assets/6113c0fe-380f-41c1-99ee-3876a2c0aa7b" />

---

Then I changed the same config to create 10 new machines:

```tf
provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "ubuntu_instances" {
    count         = 10
    ami           = "ami-0b6c6ebed2801a5cb"
    instance_type = "m7i-flex.large"
    subnet_id     = "subnet-0f356ddbb0f90faa9"

    root_block_device {
      volume_size = 50
      volume_type = "gp3"
    }

    tags = {
        Name = "ubuntu-instance-${count.index + 1}"
    }
}
```


As I changed the same terraform file to create 10 new instances, it destroyed (terraform language for deletion) the previous machine and provisioned 10 new machines:

<img width="1882" height="560" alt="Image" src="https://github.com/user-attachments/assets/eb215473-fe44-4b34-af2e-aa5a45249ca3" />

---

<img width="1762" height="729" alt="Image" src="https://github.com/user-attachments/assets/d9df3b53-1e26-4d0b-87b7-800edc4ad7d0" />















