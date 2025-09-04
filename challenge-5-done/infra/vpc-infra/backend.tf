terraform {
  backend "s3" {
    bucket = "chellange5tfstate"
    key = "vpc.tfstate"
    region = "us-east-1"
  }
}