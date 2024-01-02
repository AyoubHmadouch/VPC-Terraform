# Data source to retrieve the AZs
data "aws_availability_zones" "azs" {
  state = "available"
}