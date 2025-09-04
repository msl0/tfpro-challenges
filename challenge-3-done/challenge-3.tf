terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
  assume_role {
    role_arn = "arn:aws:iam::xxx:role/ReadOnlyRole"
  }
}

provider "aws" {
  alias                    = "iam"
  region                   = "us-east-1"
  profile                  = "iam"
  shared_config_files      = ["./.aws/conf"]
  shared_credentials_files = ["./.aws/credentials"]
}

provider "aws" {
  alias                    = "asg"
  region                   = "us-east-1"
  profile                  = "asg"
  shared_config_files      = ["./.aws/conf"]
  shared_credentials_files = ["./.aws/credentials"]
}


module "asg" {
  source = "./modules/asg"
  providers = {
    aws = aws.asg
  }
}

module "iam" {
  source = "./modules/iam"
  providers = {
    aws = aws.iam
  }
}

data "aws_caller_identity" "local" {}

resource "local_file" "this" {
  content  = data.aws_caller_identity.local.account_id
  filename = "account-number.txt"
}
