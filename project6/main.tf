terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_security_group" "ec2InstanceSG" {
  name        = "enable_ssh"
  description = "Allow SSH request from public ip address"
  tags = {
    Name = "ec2InstanceSG"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ec2InstanceSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id = aws_security_group.ec2InstanceSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
  from_port = 0
  to_port = 0
}

resource "aws_instance" "ec2Instance" {
  instance_type   = "t2.micro"
  ami             = "ami-0fbbcfb8985f9a341"
  key_name        = "bastion_key_pair"
  security_groups = [aws_security_group.ec2InstanceSG.name]
  tags            = { name : "ec2Instance" }
}


resource "aws_sns_topic" "cpu_utilization" {
  name = "cpu-utilization-topic"
}

resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.cpu_utilization.arn
  protocol  = "email"
  endpoint  = "dmoha0123@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "cput_alarm" {
  alarm_name                = "hight-cpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 10
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.cpu_utilization.arn]
  ok_actions                = [aws_sns_topic.cpu_utilization.arn]
  dimensions = {
    InstanceId = aws_instance.ec2Instance.id
  }
}

output "publicIpAddress" {
  value = aws_instance.ec2Instance.public_ip
}

