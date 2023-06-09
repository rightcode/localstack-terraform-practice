output "subnet_id" {
  value = "${aws_subnet.public_sn.id}"
}

output "security_group_ids" {
  value = "${aws_security_group.ec2_sg.id}"
}

