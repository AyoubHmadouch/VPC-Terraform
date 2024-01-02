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