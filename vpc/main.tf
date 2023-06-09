resource "aws_vpc" "vpc"{
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true   # DNSホスト名を有効化
  tags                 = {
    Name = "terraform-vpc"
  }
}
resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "terraform-default-vpc"
  }
}

resource "aws_subnet" "public_sn" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  tags       = {
    Name = "terraform-public-sn"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name = "terraform-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags   = {
    Name = "terraform-public-rt"
  }
}

resource "aws_route_table_association" "public_rt_associate" {
  subnet_id      = aws_subnet.public_sn.id
  route_table_id = aws_route_table.public_rt.id
}

data "http" "ifconfig" {
  url = "http://ipv4.icanhazip.com/"
}

variable "allowed_cidr" {
  default = null
}

locals {
  myip         = chomp(data.http.ifconfig.body)
  allowed_cidr = (var.allowed_cidr == null) ? "${local.myip}/32" : var.allowed_cidr
}

resource "aws_security_group" "ec2_sg" {
  name        = "terraform-ec2-sg"
  description = "For EC2 Linux"
  vpc_id      = aws_vpc.vpc.id
  tags        = {
    Name = "terraform-ec2-sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.allowed_cidr]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.allowed_cidr]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [local.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_default_vpc.default_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    self      = true
  }
}

