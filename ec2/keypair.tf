resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key_pem" {
  filename = "${local.private_key_file}"
  content  = "${tls_private_key.private_key.private_key_pem}"
}

resource "aws_key_pair" "keypair" {
  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.private_key.public_key_openssh}"
}

locals {
  public_key_file  = "${var.key_name}.id_rsa.pub"
  private_key_file = "${var.key_name}.id_rsa"
}

