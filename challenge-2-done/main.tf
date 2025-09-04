terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = var.environement
    }
  }
}
# resource "random_pet" "this" {}
module "random" {
  source = "./modules/random"
}

moved {
  from = random_pet.this
  to   = module.random.random_pet.this
}

# data "aws_ami" "this" {
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20241109"]
#   }
# }

# resource "aws_instance" "this" {
#   ami                  = data.aws_ami.this.id
#   instance_type        = "t2.micro"
#   iam_instance_profile = aws_iam_instance_profile.test_profile.name

# }

moved {
  from = aws_instance.this
  to   = module.ec2.aws_instance.this
}

module "ec2" {
  source = "./modules/ec2"
  ami_name = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20241109"
  instance_type = "t2.micro"
  iam_instance_profile_name = module.iam.iam_instance_profile.name
}

# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "test_role" {
#   name               = "ec2-iam-role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }

# resource "aws_iam_instance_profile" "test_profile" {
#   name = "test_profile"
#   role = aws_iam_role.test_role.name
# }

# resource "aws_iam_user" "lb" {
#   count = 3
#   name  = "${random_pet.this.id}-${var.org-name}-${count.index}"
# }

# # This policy must be associated with all IAM users created through this code.

# resource "aws_iam_user_policy" "lb_ro" {
#   name  = "ec2-describe-policy"
#   count = 3
#   user  = aws_iam_user.lb[count.index].name
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:Describe*",
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

module "iam" {
  source = "./modules/iam"
  org-name = var.org-name
  pet_name = module.random.random_pet.id
}

moved {
  from = aws_iam_user.lb
  to   = module.iam.aws_iam_user.lb
}

moved {
  from = aws_iam_user_policy.lb_ro
  to   = module.iam.aws_iam_user_policy.lb_ro
}

moved {
  from = aws_iam_role.test_role
  to   = module.iam.aws_iam_role.test_role
}

moved {
  from = aws_iam_instance_profile.test_profile
  to   = module.iam.aws_iam_instance_profile.test_profile
}

# resource "aws_s3_bucket" "example" {
#   for_each = var.s3_buckets
#   bucket   = "${random_pet.this.id}-${each.value}"
# }

# resource "aws_s3_object" "object" {
#   for_each = var.s3_buckets
#   bucket   = aws_s3_bucket.example[each.key].id
#   key      = var.s3_base_object
# }

module "s3" {
  source = "./modules/s3"
  s3_buckets = var.s3_buckets
  s3_base_object = var.s3_base_object
  pet_name = module.random.random_pet.id
}

moved {
  from = aws_s3_bucket.example
  to   = module.s3.aws_s3_bucket.example
}

moved {
  from = aws_s3_object.object
  to   = module.s3.aws_s3_object.object
}

# resource "aws_security_group" "example" {
#   name = var.sg_name
# }

# resource "aws_vpc_security_group_ingress_rule" "example" {
#   security_group_id = aws_security_group.example.id

#   cidr_ipv4   = "10.0.0.0/8"
#   from_port   = 80
#   ip_protocol = "tcp"
#   to_port     = 80
# }

module "sg" {
  source = "./modules/sg"
  sg_name = var.sg_name
}

moved {
  from = aws_security_group.example
  to   = module.sg.aws_security_group.example
}

moved {
  from = aws_vpc_security_group_ingress_rule.example
  to   = module.sg.aws_vpc_security_group_ingress_rule.example
}