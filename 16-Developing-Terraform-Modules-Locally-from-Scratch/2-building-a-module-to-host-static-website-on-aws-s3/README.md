We have added the main resource creation files in the modules directory:

---

<img width="277" height="188" alt="image" src="https://github.com/user-attachments/assets/14a017b3-a620-4ab0-b9b0-d9f5f7861291" />

---
---

And we have created a file which would create the `s3 bucket` referring from those files:


```hcl
module "s3_bucket_website" {
  source = "./modules/aws-s3-static-website-bucket"
  #bucket_name = "my_static_website-${random_pet.pet_name.id}"
  bucket_name = var.bucket_name
  tags = var.tags
}
```

---

Resources provisioned successfully:

```
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

arn = "arn:aws:s3:::my-static-s3-website-skulululu"
bucket_domain_name = "my-static-s3-website-skulululu.s3.amazonaws.com"
bucket_regional_domain_name = "my-static-s3-website-skulululu.s3.us-west-2.amazonaws.com"
name = "my-static-s3-website-skulululu"
static_website_url = "http://my-static-s3-website-skulululu.s3-website.us-west-2.amazon.com"
```

---

<img width="741" height="198" alt="image" src="https://github.com/user-attachments/assets/d68308e1-ac46-45ce-b6a1-cc2de30b04c7" />

---


















