output "vpc_id" {
  value       = aws_vpc.dev_vpc.id
  description = "The vpc id."
}

output "igw_id" {
  value       = aws_internet_gateway.igw.id
  description = "The igw id."
}

output "public_subnets_ids" {
  value       = ["${aws_subnet.public_subnets[*].id}"]
  description = "The public subntes ids."
}

output "private_subnets_ids" {
  value       = ["${aws_subnet.private_subnets[*].id}"]
  description = "The private subntes ids."
}

output "public_route_table_id" {
  value       = aws_route_table.public_route_table.id
  description = "The id of the public route table."
}

output "private_route_table_id" {
  value       = aws_route_table.private_route_table.id
  description = "The id of the private route table."
}

output "ngw_id" {
  value       = var.create_ngw ? aws_nat_gateway.ngw[0].id : null
  description = "The id of the nat gateway."
}

output "nat_eip" {
  value       = var.create_ngw ? aws_eip.ngw_eip[0].public_ip : null
  description = "The id of the nat gateway."
}