data "aws_vpc" "this" {
  tags = {
    Name = "central-vpc"
  }
  #   filter {
  #     name   = "tag:Name"
  #     values = ["central-vpc"]
  #   }
}
data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

data "aws_subnet" "this" {
  for_each = toset(data.aws_subnets.this.ids)
  id       = each.value
}

locals {
  subnet_ids = { for subnet in data.aws_subnet.this : subnet.tags.Name => subnet.id }
}

output "subnet_ids" {
  value = local.subnet_ids
}


resource "aws_security_group" "this" {
  name   = "kplabs-sg"
  vpc_id = data.aws_vpc.this.id
}

locals {
  sg_rules = csvdecode(file("./sg.csv"))
  cidr_subnet_mapping = {
    app        = "app-subnet"
    database   = "database-subnet"
    monitoring = "central-subnet"
    anti-virus = "central-subnet"
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each    = { for idx, rule in local.sg_rules : idx => rule if rule.direction == "in" }
  ip_protocol = each.value.protocol
  cidr_ipv4   = data.aws_subnet.this[local.subnet_ids[local.cidr_subnet_mapping[each.value.cidr_block]]].cidr_block
  from_port   = strcontains(each.value.port, "-") ? split("-", each.value.port)[0] : each.value.port
  to_port     = strcontains(each.value.port, "-") ? split("-", each.value.port)[1] : each.value.port

  security_group_id = aws_security_group.this.id
}

output "filtered_data" {
  value = { for idx, item in local.sg_rules : idx => {
    cidr_block = data.aws_subnet.this[local.subnet_ids[local.cidr_subnet_mapping[item.cidr_block]]].cidr_block
    from_port  = strcontains(item.port, "-") ? split("-", item.port)[0] : item.port
    to_port    = strcontains(item.port, "-") ? split("-", item.port)[1] : item.port
    }
  }
}
