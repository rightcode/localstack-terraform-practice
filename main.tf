module "vpc" {
  source = "./vpc"
}

module "ec2_web" {
  source = "./ec2"

  key_name           = "terraform-keypair-web"
  subnet_id          = module.vpc.subnet_id
  security_group_ids = module.vpc.security_group_ids
  tags               = {
    Name = "web-server"
  }
}

module "ec2_app" {
  source = "./ec2"

  key_name           = "terraform-keypair-app"
  subnet_id          = module.vpc.subnet_id
  security_group_ids = module.vpc.security_group_ids
  tags               = {
    Name = "app-server"
  }
}

module "rds" {
  source = "./rds"

  subnet_id = module.vpc.subnet_id
}

