# data "aws_subnets" "this" {
#   filter {
#     name = "vpc-id"
#     values = [ aws_vpc.main.id ]
#   }
# }

# output "subnet_ids" {
#   value = data.aws_subnets.this.ids
# }