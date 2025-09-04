resource "aws_instance" "this" {
    for_each = toset(var.subnet_ids)
    instance_type = "t3.micro"
    ami = "ami-01816d07b1128cd2d"
    subnet_id = each.value
}