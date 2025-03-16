variable "region" {
  description = "AWS region"
  type        = string
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "Region must be a valid AWS region format (e.g., us-east-1)."
  }
}


variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "subnet_cidr_private" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  validation {
    condition     = length(var.subnet_cidr_private) > 0
    error_message = "At least one private subnet CIDR block must be provided."
  }
}

variable "subnet_cidr_public" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  validation {
    condition     = length(var.subnet_cidr_public) > 0
    error_message = "At least one public subnet CIDR block must be provided."
  }
}

variable "availability_zone" {
  description = "Availability zones for subnets"
  type        = list(string)
  validation {
    condition     = length(var.availability_zone) >= 2
    error_message = "At least two availability zones must be specified for high availability."
  }
}

variable "kube_config" {
  description = "Path to the kubernetes configuration file"
  type        = string
  default     = "~/.kube/config"
}

variable "monitoring_namespace" {
  type    = string
  default = "monitoring"
}

variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

