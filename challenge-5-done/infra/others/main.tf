provider "aws" {
 region = "us-east-1"
}

module "ec2" {
  source = "../../modules/ec2"
    subnet_ids = data.terraform_remote_state.vpc.outputs.subnets_challenge_5
}

module "sg" {
  source = "../../modules/sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_main
}

import {
  id = "i-055739fca52de2839"
  to = module.ec2.aws_instance.this["subnet-05d8f50e63bd6c6ec"]
}

import {
  id = "i-095bb7a3220f5dced"
  to = module.ec2.aws_instance.this["subnet-0bc75905560a658ca"]
}

import {
  id = "sg-055614d0c9b4f073f"
  to = module.sg.aws_security_group.this["app-1-sg"]
}

import {
  id = "sg-0dbb79a0eb5005add"
  to = module.sg.aws_security_group.this["app-2-sg"]
}

import {
  id = "sgr-0b6ac10a4c010e9f8"
  to = module.sg.aws_vpc_security_group_ingress_rule.app-1-sg["0"]
}

import {
  id = "sgr-02bcae6a2653c260c"
  to = module.sg.aws_vpc_security_group_ingress_rule.app-1-sg["2"]
}

import {
  id = "sgr-0ac78d98c38175e29"
  to = module.sg.aws_vpc_security_group_ingress_rule.app-2-sg["1"]
}

import {
  id = "sgr-09fdad27ce053e819"
  to = module.sg.aws_vpc_security_group_ingress_rule.app-2-sg["3"]
}