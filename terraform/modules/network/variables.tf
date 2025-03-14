variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "availability_zone" {
  description = "Availability zones for subnets"
  type        = list(string)
}

variable "subnet_cidr_private" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "subnet_cidr_public" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}
