locals {
  vpc_name            = "${var.environment}-vpc"
  igw_name            = "${local.vpc_name}-igw"
  public_subnet_name  = "${local.vpc_name}-public-subnet"
  private_subnet_name = "${local.vpc_name}-private-subnet"
  sufixe_rt_name      = "route-table"
  ngw_name            = "${local.vpc_name}-ngw"
}
// VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.vpc_tenancy

  tags = {
    Name = local.vpc_name
  }
}
// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = local.igw_name
  }
}
// Public subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidr_block)
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = element(var.public_subnets_cidr_block, count.index)
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name        = "${local.public_subnet_name}-${count.index + 1}"
    Environment = var.environment
  }
}
// Private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_cidr_block)
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = element(var.private_subnets_cidr_block, count.index)
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name        = "${local.private_subnet_name}-${count.index + 1}"
    Environment = var.environment
  }
}
// Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-${local.sufixe_rt_name}"
  }
}
// Private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "private-${local.sufixe_rt_name}"
  }
}
// Public route table association
resource "aws_route_table_association" "public_route_table_ass" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets, count.index).id
  route_table_id = aws_route_table.public_route_table.id
}
// Private route table association
resource "aws_route_table_association" "private_route_table_ass" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets, count.index).id
  route_table_id = aws_route_table.private_route_table.id
}
// Elastic ip address
resource "aws_eip" "ngw_eip" {
  count  = var.create_ngw ? 1 : 0
  domain = "vpc"
}
// Nat Gateway 
resource "aws_nat_gateway" "ngw" {
  count             = var.create_ngw ? 1 : 0
  connectivity_type = "public"
  allocation_id     = aws_eip.ngw_eip[count.index].id
  subnet_id         = aws_subnet.public_subnets[0]

  depends_on = [aws_internet_gateway.igw, aws_eip.ngw_eip]

  tags = {
    Name = local.ngw_name
  }
}