terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  csv_file  = file("./ec2.csv")
  config    = csvdecode(local.csv_file)
  instances = [ for vm in local.config : vm if vm.Region == "us-east-1" ]
  instance_types = {
    micro = "t2.micro"
    nano  = "t3.nano"
  }
}


resource "aws_instance" "this" {
  count         = length(local.instances)
  instance_type = local.instance_types[local.instances[count.index].instance_type]
  ami           = local.instances[count.index].AMI_ID
  tags = {
    Name = local.instances[count.index].Team_Name
  }
}

output "running_ec2" {
  value = [for idx, ec2 in aws_instance.this : {
        firewall_id = ec2.vpc_security_group_ids
        id = ec2.id
        region = local.instances[idx].Region
        subnet = ec2.subnet_id
        team = ec2.tags["Name"]
        type = local.instances[idx].instance_type
    }
  ]
}
