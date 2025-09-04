
variable "environement" {
  type = string
  default = "dev"
}

variable "s3_buckets" {
  type = list(string)
}

variable "s3_base_object" {}

variable "org-name" {}

variable "region" {}

variable "sg_name" {}