## 📄 Static Website on S3 with CloudFront CDN

This project uses Terraform to deploy a static website on AWS S3 and speed it up globally with CloudFront CDN.

---

### 🛠 Key Skills

- `aws_s3_bucket`
- `aws_s3_bucket_policy`
- `aws_s3_bucket_website_configuration`
- `aws_cloudfront_distribution`
- Static Website Hosting
- CDN Acceleration

---

### 📚 Project Overview

| Layer         | Resource                                                             | Purpose                      |
| ------------- | -------------------------------------------------------------------- | ---------------------------- |
| Storage       | **S3 Bucket** (`aws_s3_bucket`)                                      | Store your static site files |
| Public Access | **S3 Bucket Policy** (`aws_s3_bucket_policy`)                        | Make files readable publicly |
| Hosting       | **S3 Website Configuration** (`aws_s3_bucket_website_configuration`) | Serve files over HTTP        |
| Speed Boost   | **CloudFront Distribution** (`aws_cloudfront_distribution`)          | Cache and serve globally     |

---

### 🏗 Resources Breakdown

#### 1. S3 Bucket

Creates an S3 bucket to store the static website files.

```hcl
resource "aws_s3_bucket" "static_site" { ... }
```

- `force_destroy = true` allows the bucket to be deleted even if it has objects.

---

#### 2. S3 Bucket Website Configuration

Configures the S3 bucket for **static website hosting**, setting `index.html` as the root.

```hcl
resource "aws_s3_bucket_website_configuration" "static_website" { ... }
```

---

#### 3. Upload `index.html` to S3

Uploads the `index.html` file into the S3 bucket with proper metadata.

```hcl
resource "aws_s3_object" "object" { ... }
```

---

#### 4. S3 Bucket Public Access Policy

Creates a bucket policy to allow **public read** access to all objects.

```hcl
resource "aws_s3_bucket_policy" "public_policy" { ... }
```

- Depends on disabling S3 block public access first.

---

#### 5. S3 Bucket Public Access Block

Disables the default public access blocking settings so the bucket policy can apply.

```hcl
resource "aws_s3_bucket_public_access_block" "public_access" { ... }
```

---

#### 6. CloudFront Distribution (CDN)

Creates a CloudFront distribution to accelerate your static website globally.

```hcl
resource "aws_cloudfront_distribution" "cdn" { ... }
```

- Caches static content at AWS edge locations.
- Forces HTTPS access using AWS’s default SSL cert.
- No geo-restrictions.

---

#### 7. Outputs

Outputs the URLs for the deployed site:

```hcl
output "cdn_domain" { ... }
output "website_url" { ... }
```

- `cdn_domain`: CloudFront URL for your website.
- `website_url`: S3 website endpoint.

---

### ⚙️ How to Deploy

1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2. Configure your AWS credentials (`aws configure`).
3. Initialize and apply Terraform:

```bash
terraform init
terraform apply
```

✅ After deployment, visit your website via the CloudFront domain!

---

### 🌟 Future Improvements (Optional)

- Attach a custom domain with SSL (AWS ACM).
- Add an Origin Access Identity (OAI) to make S3 bucket **private**.
- Set up cache invalidation for faster updates.
- Expand the site to handle multi-page apps.

---

### 🚀 Final Result

- **Fast**, **secure**, and **globally available** static website powered by **AWS S3** + **CloudFront**.
- Fully managed using **Terraform Infrastructure as Code (IaC)**.

---

## 📄 License

This project is released under the MIT License.
