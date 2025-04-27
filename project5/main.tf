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

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "publicSubnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicSubnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "example"
  }
}

resource "aws_route" "publicRoute" {
  route_table_id         = aws_route_table.publicRouteTable.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "publicSubnetAssociation" {
  subnet_id      = aws_subnet.publicSubnet.id
  route_table_id = aws_route_table.publicRouteTable.id
}


resource "aws_security_group" "publicInstanceSG" {
  name        = "allow_http_ssh"
  description = "Allow http access and ssh access to instance"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_http_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allowHttp" {
  security_group_id = aws_security_group.publicInstanceSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allowSsh" {
  security_group_id = aws_security_group.publicInstanceSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id = aws_security_group.publicInstanceSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  from_port         = 0
  to_port           = 0
}

resource "aws_instance" "publicInstance" {
  ami                    = "ami-0fbbcfb8985f9a341"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.publicSubnet.id
  key_name               = "bastion_key_pair"
  vpc_security_group_ids = [aws_security_group.publicInstanceSG.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd

              sudo tee /var/www/html/index.html > /dev/null <<EOT
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <title>Welcome to My EC2 Site</title>
                  <style>
                      body { background-color: #f0f0f0; font-family: Arial, sans-serif; text-align: center; padding-top: 50px; }
                      h1 { color: #333; }
                      p { color: #666; }
                  </style>
              </head>
              <body>
                  <h1>Hello from EC2!</h1>
                  <p>Deployed with Terraform and Apache</p>
              </body>
              </html>
              EOT
              EOF

  tags = {
    Name = "publicInstance"
  }
}

## If you want the same ip address instead of new ones when you create and destroy ec2 instances us this
# resource "aws_eip" "eip" {
#   depends_on = [aws_internet_gateway.igw]
# }

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.publicInstance.id
#   allocation_id = aws_eip.eip.id
# }

resource "aws_route53_zone" "my_zone" {
  name = "yourdomain.com" # replace with your real domain
}

resource "aws_route53_record" "site" {
  zone_id = aws_route53_zone.my_zone.id
  name    = "www"
  type    = "A"
  ttl     = 300
  records = [aws_instance.publicInstance.public_ip]  #[aws_eip.eip.public_ip] if you use elastic ip
}




# output "elaticIpAddress" {
#   value = aws_eip.eip.public_ip
# }

output "publicIpAddress" {
  value = aws_instance.publicInstance.public_ip
}

output "privateIpAddress" {
  value = aws_instance.publicInstance.private_ip
}
