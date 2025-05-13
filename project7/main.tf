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
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  tags = {
    Name : "ec2InstanceSG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allowSsh" {
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
  from_port         = 0
  to_port           = 0
}

resource "aws_instance" "ec2Instance" {
  availability_zone      = "eu-west-2a"
  ami                    = "ami-0fbbcfb8985f9a341"
  instance_type          = "t2.micro"
  key_name               = "bastion_key_pair"
  vpc_security_group_ids = [aws_security_group.ec2InstanceSG.id]
  user_data              = <<-EOF
              #!/bin/bash
              mkfs.ext4 /dev/sdh
              mkdir /mnt/volume
              mount /dev/sdh /mnt/volume
              echo "/dev/sdh /mnt/volume ext4 defaults,nofail 0 2" >> /etc/fstab
              EOF
  tags = {
    Name : "ec2Instance"
  }
}

resource "aws_ebs_volume" "ebsVolume" {
  availability_zone = "eu-west-2a"
  size              = 1
  type              = "gp2"
  tags = {
    Name = "HelloWorld"
  }
}


resource "aws_volume_attachment" "attachEbsToEc2" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebsVolume.id
  instance_id = aws_instance.ec2Instance.id
}

output "instanceId" {
  value = aws_instance.ec2Instance.id
}

output "volumeId" {
  value = aws_ebs_volume.ebsVolume.id
}

output "publicIpInstance" {
  value = aws_instance.ec2Instance.public_ip
}