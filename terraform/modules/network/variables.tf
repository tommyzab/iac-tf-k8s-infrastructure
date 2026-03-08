variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "application" {
  description = "Application or project name"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

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
