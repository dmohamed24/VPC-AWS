# EC2 Instance with CPU Utilization Alarm and Email Notification (Terraform)

This Terraform project provisions an Amazon EC2 instance, configures security groups, and sets up a CloudWatch alarm that monitors CPU utilization. When the CPU usage exceeds a defined threshold, an email notification is sent using Amazon SNS. Another email is sent when the CPU usage returns to a normal level.

---

## 🚀 Features

- Launches an EC2 instance in the `eu-west-2` region.
- Configures security groups to allow SSH access (port 22).
- Sets up a CloudWatch alarm to monitor EC2 CPU utilization.
- Sends email notifications via SNS when:
  - CPU usage exceeds the threshold (ALARM state).
  - CPU usage returns to normal (OK state).

---

## 🧾 Requirements

- An AWS account with proper permissions.
- AWS CLI installed and configured.
- Terraform installed (v1.0+ recommended).
- A valid, accessible email address (you must confirm the SNS subscription).

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

## Confirm the Email Subscription

Check your email inbox for a message from AWS SNS and click the confirmation link to enable email notifications.

## 💻 Access the EC2 Instance
Use SSH to connect:

```
    ssh -i /path/to/your-key.pem 
    ec2-user@<public_ip>
```
Replace <public_ip> with the one output by Terraform.

## 🔄 Simulate High CPU Usage (Optional)
To test the alarm:

Install the stress tool:

```
sudo yum install -y epel-release
sudo yum install -y stress
stress --cpu 2 --timeout 120
```

This will simulate high CPU usage for 5 minutes and should trigger the CloudWatch alarm and SNS notification.

## ✅ Clean Up
To destroy all created resources:

```
terraform destroy
```


## 📝 Notes
The CloudWatch alarm is configured to trigger at CPU utilization ≥ 10%.

An email will be sent when the alarm state changes to ALARM or OK.

Be sure to confirm the SNS subscription to receive alerts.

## License

This project is licensed under the MIT License.
