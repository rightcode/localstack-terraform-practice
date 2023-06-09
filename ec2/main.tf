resource "aws_instance" "ec2"{
  ami                         = "ami-000001"
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  security_groups             = [var.security_group_ids]
  associate_public_ip_address = "true"
  key_name                    = var.key_name
  tags                        = var.tags
}

