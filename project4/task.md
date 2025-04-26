# Terraform Project: IAM User with Limited S3 Access

## Overview

This Terraform project creates an IAM user with **programmatic access** and attaches a policy that provides **read-only permissions** to Amazon S3, specifically:

- `s3:ListBucket`
- `s3:GetObject`

---

## Features

- Creates an **IAM User** named `limited-s3-user`.
- Generates an **Access Key** for programmatic access.
- Attaches a custom **IAM Policy** allowing S3 read-only access.

---

## Key Skills Highlighted

- `aws_iam_user`
- `aws_iam_access_key`
- `aws_iam_policy_document`
- `aws_iam_user_policy`

---

## Breakdown

Use aws_iam_user to create the IAM user.

Use aws_iam_access_key to generate programmatic access (Access Key ID + Secret).

Use aws_iam_policy_document to define a custom policy (for s3:ListBucket and s3:GetObject).

Use aws_iam_user_policy_attachment (or aws_iam_user_policy directly) to attach it to the user.

---

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) installed (v1.0 or later recommended)
- AWS credentials configured on your machine (`aws configure`)

---

## ⚙️ How to Deploy

1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2. Configure your AWS credentials (`aws configure`).
3. Initialize and apply Terraform:

```bash
terraform init
terraform apply
```

---


## 🚀 Final Result
- This IAM user will have read-only access to all S3 buckets in the AWS account.

- To restrict access to specific buckets, modify the resources field in the IAM policy document.

- Access keys are sensitive and should be rotated periodically for security best practices.


---

## 📄 License

This project is released under the MIT License.
