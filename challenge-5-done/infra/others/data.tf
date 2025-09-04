data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "chellange5tfstate"
    key    = "vpc.tfstate"
    region = "us-east-1"
  }
}
