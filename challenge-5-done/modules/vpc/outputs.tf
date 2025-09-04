output "subnets_challenge_5" {
  value = [ for key, value in aws_subnet.challenge_5 : value.id ]
}

output "vpc_main" {
  value = aws_vpc.main.id
}