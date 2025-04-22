# AWS Bastion Host with Private EC2 Access

This Terraform project provisions an AWS environment designed to demonstrate secure SSH access to a public EC2 instance (bastion host) and enable ICMP (ping) connectivity to a private EC2 instance within a VPC.

---

## 🧠 Project Overview

This setup creates:

- A **VPC** with public and private subnets.
- A **public EC2 instance** (bastion host) in the public subnet, accessible via SSH from anywhere.
- A **private EC2 instance** in the private subnet, not exposed to the internet.
- A **security group** allowing:
  - SSH and ICMP to the public instance.
  - ICMP within the VPC to the private instance.

The goal is to SSH into the public EC2 and then ping the private EC2, demonstrating internal network connectivity between instances even when the private EC2 has no direct internet access.

---

## ⚙️ Architecture

┌────────────────────────────────────────────┐
│                   VPC                     │
│              (10.0.0.0/16)                │
│                                            │
│  ┌────────────┐       ┌─────────────────┐ │
│  │ Public     │       │ Private         │ │
│  │ Subnet     │       │ Subnet          │ │
│  │ 10.0.1.0/24│       │ 10.0.2.0/24     │ │
│  │            │       │                 │ │
│  │  EC2       │       │  EC2            │ │
│  │ (Bastion)  │ <---> │ (Private)       │ │
│  └────────────┘       └─────────────────┘ │
│                                            │
│ Internet Gateway (for public subnet)       │
└────────────────────────────────────────────┘


---

## 🚀 How to Use

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed.
- An existing **AWS key pair** (replace `bastion_key_pair` with your own).
- AWS CLI configured or environment credentials set.

---

### Deployment Steps

1. **Initialize Terraform:**

```
terraform init
```

2. **Deployment:**

```
terraform plan
```
3. **Apply the Configuration**

```
terraform apply
```
4. **Apply the Configuration**
- Once applied, Terraform will output the public instance's IP. SSH into it:

```
ssh -i /path/to/your/key.pem ec2-user@<PUBLIC_INSTANCE_IP>

```
5. **Apply the Configuration**
- Inside the bastion instance:

```
ping 10.0.2.X <PUBLIC_INSTANCE_IP>

```

## 🔐 Security Groups Overview
Public EC2:

SSH (port 22) allowed from anywhere (0.0.0.0/0).

ICMP allowed from anywhere.

Outbound traffic allowed to any destination.

Private EC2:

ICMP allowed from any resource inside the VPC (10.0.0.0/16).

No internet exposure.


## 🧹 Cleanup
To tear down the infrastructure:

```bash
terraform destroy
```



## 📄 License
This project is released under the MIT License.