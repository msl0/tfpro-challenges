variable "ami_name" {
  type        = string
  description = "The name of the AMI to use for the instance"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to create"
}

variable "iam_instance_profile_name" {
  type        = string
  description = "The name of the IAM instance profile to associate with the instance"
}