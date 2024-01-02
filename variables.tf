variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "The region where to deploy the VPC."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "The environment of resources."
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR Block for the VPC."
}

variable "vpc_tenancy" {
  type    = string
  default = "default"
}

variable "public_subnets_cidr_block" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "The CIDR blocks for the public subnets."
}

variable "private_subnets_cidr_block" {
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  description = "The CIDR blocks for the private subnets."
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = true
  description = "If true, the instances launched into the subnet should be assigned a public IP address."
}

variable "create_ngw" {
  type        = bool
  default     = false
  description = "Provision a nat gateway if needed."
}