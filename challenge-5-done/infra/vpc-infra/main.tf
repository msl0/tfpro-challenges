provider "aws" {
 region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"
}

import {
  id = "vpc-045860752943a2993"
  to = module.vpc.aws_vpc.main
}

import {
  id = "vpc-037ad542e8ae547de"
  to = module.vpc.aws_vpc.random
}

import {
  id = "subnet-05d8f50e63bd6c6ec"
  to = module.vpc.aws_subnet.challenge_5["subnet1"]
}

import {
  id = "subnet-0bc75905560a658ca"
  to = module.vpc.aws_subnet.challenge_5["subnet2"]
}

import {
  id = "subnet-05d1beba5a400f6f5"
  to = module.vpc.aws_subnet.random["subnet1"]
}

import {
  id = "subnet-088b34aef6275770c"
  to = module.vpc.aws_subnet.random["subnet2"]
}