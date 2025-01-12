variable "prefix" {
  description = "Name of my prefix"
  type        = string
}

variable "region" {
  description = "Region"
  default     = "us-east-1"
  type        = string
}

variable "vpc_cidr" {
  description = "The cidr of the vpc"
  # default     = "10.0.0.0/16"
  type        = string
}


variable "subnet_cidr_private" {
  description = "cidr blocks for the private subnets"
  # default     = ["10.0.1.0/24", "10.0.2.0/24"]
  type        = list(any)
}

variable "subnet_cidr_public" {
  description = "cidr blocks for the public subnets"
  # default     = ["10.0.3.0/24", "10.0.4.0/24"]
  type        = list(any)
}

variable "availability_zone" {
  description = "availability zones for the private subnets"
  # default     = ["us-east-1a", "us-east-1b"]
  type        = list(any)
}
