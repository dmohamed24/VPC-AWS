# AWS EC2 Public Instance with Terraform

## 🧾 Overview

This project uses Terraform to provision a basic AWS environment including:

- A VPC with public subnet
- An Internet Gateway and Route Table
- An EC2 instance with SSH access
- A Security Group allowing SSH and (optionally) HTTP access

---

## 💻 Prerequisites

- [Terraform](https://www.terraform.io/downloads)
- AWS credentials configured (`~/.aws/credentials`)
- A pre-existing EC2 key pair in AWS (`bastion_key_pair.pem`)

---

## 🚀 Usage

1. **Initialize Terraform**
   ```
   terraform init
   ```


2. **Deploy infrastructure**
    ```
    terraform apply
    ```

3. **SSH into EC2 instance**

    ```
    ssh -i bastion_key_pair.pem ec2-user@<EC2_PUBLIC_IP>
    ```

4. **Deploy a Simple Web Server**

- Amazon linux platform

    ```
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd 
    sudo systemctl enable httpd  
    echo "Hello from $(hostname)!" | sudo tee /var/www/html/index.html
    ```

- Open your browser and visit:

    ```
    http://<EC2_PUBLIC_IP>
    ```

5. **Clean up**

- Destroy all resources created by Terraform:

    ```
    terraform destroy
    ```
        
    