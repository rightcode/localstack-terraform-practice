provider "aws" {
  region                      = "ap-northeast-1"
  access_key                  = "dummy"
  secret_key                  = "dummy"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
    rds = "http://localhost:4566"
  }
}

provider "http" {}

