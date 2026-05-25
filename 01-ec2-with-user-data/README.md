Here we are trying to provision an EC2 wtih some user-data using Terraform.

We wrote all the necessary files: </br>
[user data file](/ec2-with-user-data/hostname.sh) </br>
[version file with the terraform and provider block](/ec2-with-user-data/i1-version.tf) </br>
[resource file with the resources definition](/ec2-with-user-data/i1-main.tf) </br>

Then we run:
```terraform init```

But there was some with the version that we selected:

---

<img width="1108" height="710" alt="image" src="https://github.com/user-attachments/assets/849a57e2-b1c2-4888-a748-d0ddbf14d04d" />

---

There was a version mismatch between the desired and the current version available in our system.

So we upgrade our system version to the latest one:

```bash
sudo apt update
sudo apt install --only-upgrade terraform
```

Got one important error:

---

<img width="837" height="282" alt="image" src="https://github.com/user-attachments/assets/b1b9de91-a85c-4f95-83cd-5dac0e7eef1b" />

---

I copied the AMI ID of a different region which was not available in the region that I selected so I changed it and then again ran
```
terraform plan
```

It's very crucial to run `terraform plan`  -- `<write reason also>`

---
<img width="829" height="263" alt="image" src="https://github.com/user-attachments/assets/014419d1-0db4-4bdf-bafa-2da31441562e" />

---

<img width="1086" height="221" alt="image" src="https://github.com/user-attachments/assets/6db314a3-db65-407c-8bc0-3ffdeb7ab6c3" />
















