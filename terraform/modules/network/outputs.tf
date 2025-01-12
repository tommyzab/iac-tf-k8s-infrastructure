output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "nat_gateway_id_1" {
  value = aws_nat_gateway.nat_gateway_1.id
}


output "nat_gateway_id_2" {
  value = aws_nat_gateway.nat_gateway_2.id
}