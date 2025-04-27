## Route53 DNS Record for EC2
Map a domain (or subdomain) to an EC2 instance.

Use Route53 to create an A record pointing to your EC2’s public IP.

Optional: Use a free domain from Freenom or AWS Route53.
Key Skills: aws_route53_zone, aws_route53_record


# Terraform AWS Infrastructure Setup

## Overview

This Terraform project creates a simple AWS environment consisting of:

- A Virtual Private Cloud (VPC)
- A Public Subnet
- An Internet Gateway
- A Route Table with a public route
- Security Groups allowing SSH and HTTP
- A Public EC2 Instance running Apache
- An optional Elastic IP (for static public IP)
- A Route53 DNS Record pointing to the instance

-----

## Prerequisites

- AWS Account
- Terraform installed (v1.0 or later)
- An existing Route53 hosted zone (or Terraform will create one)
- AWS credentials configured (via environment variables, `~/.aws/credentials`, or IAM roles)

-----

## Usage

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Preview the Terraform plan

```bash
terraform plan
```

### 3. Apply the Terraform configuration

```bash
terraform apply
```

Confirm with `yes` when prompted.

-----

## Key Terraform Resources

### VPC and Networking

- Create a VPC (`aws_vpc`)
- Create a Public Subnet (`aws_subnet`)
- Create an Internet Gateway (`aws_internet_gateway`)
- Create a Route Table and associate it with the Subnet (`aws_route_table`, `aws_route`, `aws_route_table_association`)

### Security Groups

- Allow inbound HTTP (port 80) and SSH (port 22)
- Allow all outbound traffic

### EC2 Instance

- Launch a `t2.micro` EC2 instance
- Install and start Apache (`httpd`)
- Serve a simple HTML page on HTTP

### Optional Elastic IP

To keep the same IP address even when destroying and recreating the EC2 instance:

```hcl
resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.publicInstance.id
  allocation_id = aws_eip.eip.id
}
```

Then update Route53 to point to the Elastic IP.

-----

## Route53 Configuration

- A Hosted Zone is created (or referenced if existing).
- An A record (`www.yourdomain.com`) is created pointing to the EC2 Public IP or Elastic IP.

Example:

```hcl
resource "aws_route53_record" "site" {
  zone_id = aws_route53_zone.my_zone.id
  name    = "www"
  type    = "A"
  ttl     = 300
  records = [aws_instance.publicInstance.public_ip]
  # or [aws_eip.eip.public_ip] if using Elastic IP
}
```

-----

## Outputs

After deployment, Terraform will output:

- The Public IP address of the instance
- The Private IP address of the instance

Example:

```hcl
output "publicIpAddress" {
  value = aws_instance.publicInstance.public_ip
}

output "privateIpAddress" {
  value = aws_instance.publicInstance.private_ip
}
```

-----

## Notes

- Ensure your domain name's NS records point to the Route53 hosted zone if you are creating a new one.
- Elastic IPs may incur a small charge if left unattached to any resource.

-----

## License

This project is licensed under the MIT License.
