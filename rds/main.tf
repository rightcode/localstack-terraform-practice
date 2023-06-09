resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  db_name              = "terraform_practice"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "terraform"
  password             = "terraform!"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  tags                 = {
    Name = "terraform-rds"
  }
}

resource "aws_db_subnet_group" "rds-subnet" {
  name        = "rds-subnet"
  subnet_ids  = [var.subnet_id]
  tags        = {
    Name = "terraform-rds-subnet"
  }
}

