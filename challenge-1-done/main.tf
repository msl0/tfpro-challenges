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
resource "random_pet" "this" {}

resource "aws_iam_user" "lb" {
  count = 3
  name  = "${random_pet.this.id}-${var.org-name}-${count.index}"
}


# This policy must be associated with all IAM users created through this code.

resource "aws_iam_user_policy" "lb_ro" {
  count = length(aws_iam_user.lb)
  name  = "ec2-describe-policy"
  user  = aws_iam_user.lb[count.index].name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_s3_bucket" "example" {
  force_destroy = true
  for_each = toset(var.s3_buckets)
  bucket   = "${random_pet.this.id}-${each.value}"
}

resource "aws_s3_object" "object" {
  for_each = aws_s3_bucket.example
  bucket   = aws_s3_bucket.example[each.key].id
  key      = var.s3_base_object
}

resource "aws_s3_object" "new" {
  for_each = aws_s3_bucket.example
  bucket   = aws_s3_bucket.example[each.key].id
  key      = "new.txt"
  content  = "Success"
}

output "s3_buckets" {
  value = [for bucket in aws_s3_bucket.example : bucket.bucket]
}

# output "sg_id" {
#   value = aws_security_group.example.id
# }

# output "sg_rule_id" {
#   value = aws_vpc_security_group_ingress_rule.example.id
# }

output "user_names" {
  value = aws_iam_user.lb[*].name
}
