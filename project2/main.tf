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

resource "aws_vpc" "mainVpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainVpc.id
  tags = {
    Name = "igw"
  }
}

resource "aws_subnet" "publicSubnet" {
  vpc_id                  = aws_vpc.mainVpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicSubnet"
  }
}

resource "aws_subnet" "privateSubnet" {
  vpc_id                  = aws_vpc.mainVpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-2a"
  tags = {
    Name = "privateSubnet"
  }
}

resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.mainVpc.id
  tags = {
    Name = "publicRouteTable"
  }
}

resource "aws_route" "publicRoute" {
  route_table_id         = aws_route_table.publicRouteTable.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "publicSubetAssociation" {
  subnet_id      = aws_subnet.publicSubnet.id
  route_table_id = aws_route_table.publicRouteTable.id
}

resource "aws_security_group" "publicInstanceSG" {
  name        = "enable_ssh"
  description = "Allow SSH request from public ip address"
  vpc_id      = aws_vpc.mainVpc.id
    tags = {
    Name = "publicInstanceSG"
  }
}

resource "aws_security_group" "privateInstanceSG" {
  name        = "enable_ping"
  description = "Allow ping requests from LAN resources"
  vpc_id      = aws_vpc.mainVpc.id
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"] #allow icmp from within the vpc
  }

  tags = {
    Name = "privateInstanceSG"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.publicInstanceSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_icmp" {
  security_group_id = aws_security_group.publicInstanceSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id = aws_security_group.publicInstanceSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
  from_port = 0
  to_port = 0
}

resource "aws_instance" "publicInstance" {
  ami                    = "ami-0fbbcfb8985f9a341"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.publicSubnet.id
  key_name               = "bastion_key_pair"
  vpc_security_group_ids = [aws_security_group.publicInstanceSG.id]
  tags = {
    Name = "publicInstance"
  }
}

resource "aws_instance" "privateInstance" {
  ami                    = "ami-0fbbcfb8985f9a341"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.privateSubnet.id
  key_name               = "bastion_key_pair"
  vpc_security_group_ids = [aws_security_group.privateInstanceSG.id]
  tags = {
    Name = "privateInstance"
  }
}