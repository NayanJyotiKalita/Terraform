```hcl
# S3 static website bucket

# Resource-1: aws_s3_bucket
resource "aws_s3_bucket" "mywebsite" {
  bucket = "mybucket-${random_pet.random.id}"
  force_destroy = true
  tags = var.tags
}

# Resource-2: aws_s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "mywebsite_config" {
  bucket = aws_s3_bucket.mywebsite.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Resource-3: aws_s3_bucket_versioning
resource "aws_s3_bucket_versioning" "mywebsite_versioning" {
  bucket = aws_s3_bucket.mywebsite.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Resource-4: aws_s3_bucket_ownership_controls
resource "aws_s3_bucket_ownership_controls" "mywebsite_ownership" {
  bucket = aws_s3_bucket.mywebsite.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Resource-5: aws_s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "mywebsite_public_access" {
  bucket = aws_s3_bucket.mywebsite.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Resource-6: aws_s3_bucket_acl
resource "aws_s3_bucket_acl" "mywebsite_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.mywebsite_ownership,
    aws_s3_bucket_public_access_block.mywebsite_public_access
  ]
  bucket = aws_s3_bucket.mywebsite.id
  acl    = "public-read"
}

# Resource-7: aws_s3_bucket_policy
resource "aws_s3_bucket_policy" "mywebsite_policy" {
  bucket = aws_s3_bucket.mywebsite.id
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Principal": "*",
			"Effect": "Allow",
			"Action": [
				"s3:GetObject"
			],
			"Resource": [
				"arn:aws:s3:::${aws_s3_bucket.mywebsite.bucket}/*"
			]
		},
    
		{
			"Sid": "Statement2",
			"Principal": "*",
			"Effect": "Allow",
			"Action": [
			    "s3:PutBucketPolicy"
			 ],
			"Resource": [
			    "arn:aws:s3:::${aws_s3_bucket.mywebsite.bucket}"
	        ]
		}
	]
}
EOF
}
```
---

### Resources provisioned successfully

```
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

arn = "arn:aws:s3:::mybucket-distinct-goose"
bucket_domain_name = "mybucket-distinct-goose.s3.amazonaws.com"
bucket_region = "us-west-2"
bucket_regional_domain_name = "mybucket-distinct-goose.s3.us-west-2.amazonaws.com"
name = "mybucket-distinct-goose"
static_website_url = "http://mybucket-distinct-goose.s3-website.us-west-2.amazon.com"
```

### Right now we won't be able to see anything in the static website url - we need to upload the index.html file

- We upload this file as `index.html` and can see our static website

---

<img width="639" height="198" alt="Screenshot 2026-06-23 144321" src="https://github.com/user-attachments/assets/2623a9ef-46ac-43af-a048-381cc4e38975" />

---

