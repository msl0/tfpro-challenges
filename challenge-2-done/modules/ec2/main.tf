data "aws_ami" "this" {
  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

resource "aws_instance" "this" {
  ami                  = data.aws_ami.this.id
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile_name

}
