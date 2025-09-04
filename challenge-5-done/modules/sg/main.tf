resource "aws_security_group" "this" {
  for_each = toset(["app-1-sg", "app-2-sg"])
  name     = each.value
  vpc_id   = var.vpc_id
}

locals {
  sg_rules = csvdecode(file("../../base-folder/sg.csv"))
}

resource "aws_vpc_security_group_ingress_rule" "app-1-sg" {
  for_each          = { for idx, rule in local.sg_rules : idx => rule if(rule.description == "app-1" && rule.direction == "in") }
  security_group_id = aws_security_group.this["app-1-sg"].id

  ip_protocol = each.value.protocol
  cidr_ipv4   = each.value.cidr_block
  to_port     = each.value.port
  from_port   = each.value.port
}


resource "aws_vpc_security_group_ingress_rule" "app-2-sg" {
  for_each          = { for idx, rule in local.sg_rules : idx => rule if(rule.description == "app-2" && rule.direction == "out") }
  security_group_id = aws_security_group.this["app-2-sg"].id

  ip_protocol = each.value.protocol
  cidr_ipv4   = each.value.cidr_block
  to_port     = each.value.port
  from_port   = each.value.port
}
