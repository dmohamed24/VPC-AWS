# EC2 Instance with EBS Volume Attachment (Terraform)

This Terraform project provisions an Amazon EC2 instance in the `eu-west-2` region, creates an EBS volume, and attaches it to the instance as persistent storage. The volume is automatically formatted, mounted, and configured to persist across reboots.

---

## 🚀 Features

- Launches an EC2 instance in the `eu-west-2a` Availability Zone.
- Configures a security group to allow SSH access (port 22).
- Creates and attaches a 1GB EBS volume (gp2 type) to the EC2 instance.
- Automatically formats the volume as `ext4` and mounts it to `/mnt/volume`.
- Adds the mount to `/etc/fstab` for persistence after reboot.

---

## 🧾 Requirements

- An AWS account with sufficient IAM permissions.
- AWS CLI installed and configured.
- Terraform installed (v1.0+ recommended).
- An existing EC2 key pair in the region (`bastion_key_pair` used here).

---

## 🛠️ Setup Instructions

1. **Clone the Repository**

```
git clone <your-repo-url>
cd <project-directory>
```
2. Initialize Terraform

```
terraform init
```

3. Apply the Terraform Configuration

```
terraform apply
```

Review the plan and type yes to confirm deployment.

## 💻 Access the EC2 Instance

- Use SSH to connect:
```
ssh -i /path/to/your-key.pem ec2-user@<public_ip>

```
- Replace <public_ip> with the one output by Terraform (publicIpInstance output).

## 📦 Verify the EBS Volume Attachment

- Once connected to the instance, you can run the following to confirm the EBS volume is mounted:

```
df -h

```
- You should see /dev/xvdh or similar mounted at /mnt/volume.

## ✅ Clean Up
To destroy all created resources:

```
terraform destroy
```


## 📝 Notes
The EBS volume is 1GB using the gp2 volume type.

Mounted at /mnt/volume, and persists across instance reboots via /etc/fstab.

Make sure to use a valid key pair that exists in your AWS region.


## License

This project is licensed under the MIT License.