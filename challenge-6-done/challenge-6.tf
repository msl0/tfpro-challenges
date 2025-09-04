terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

provider "aws" {
  alias                    = "iam-access"
  profile                  = "iam-access"
  shared_config_files      = ["./.aws/config"]
  shared_credentials_files = ["./.aws/credentials"]
}

provider "aws" {
  alias                    = "ec2-access"
  profile                  = "ec2-access"
  shared_config_files      = ["./.aws/config"]
  shared_credentials_files = ["./.aws/credentials"]
}

provider "aws" {
  alias                    = "readonly-access"
  access_key = ""
  secret_key = ""
  assume_role {
    role_arn = "arn:aws:iam::xxx:role/ReadOnlyRole"
  }
}

resource "aws_security_group" "allow_tls" {
  provider = aws.ec2-access
  name = "demo-firewall"

}

data "aws_caller_identity" "current" {
  provider = aws.readonly-access
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

resource "aws_iam_role_policy_attachment" "this" {
  provider = aws.iam-access
   policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
   role = aws_iam_role.cw_full_access.name
   
}

resource "aws_iam_role" "cw_full_access" {
  provider = aws.iam-access
  name                = "CloudWatchFullAccess"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
