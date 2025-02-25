variable "prefix" {
  description = "Prefix to be used for all resources created by this infrastructure"
  type        = string
  validation {
    condition     = length(var.prefix) > 2 && length(var.prefix) <= 10
    error_message = "Prefix must be between 3 and 10 characters long."
  }
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "Region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC network"
  type        = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "subnet_cidr_private" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  validation {
    condition     = length(var.subnet_cidr_private) > 0
    error_message = "At least one private subnet CIDR block must be provided."
  }
}

variable "subnet_cidr_public" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  validation {
    condition     = length(var.subnet_cidr_public) > 0
    error_message = "At least one public subnet CIDR block must be provided."
  }
}

variable "availability_zone" {
  description = "List of AWS availability zones for subnet placement"
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
  description = "Kubernetes namespace for monitoring tools"
  type        = string
  default     = "monitoring"
}

variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD deployment"
  type        = string
  validation {
    condition     = length(var.argocd_namespace) > 0
    error_message = "ArgoCD namespace must not be empty."
  }
}

