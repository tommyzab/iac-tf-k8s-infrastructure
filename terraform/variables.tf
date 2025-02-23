variable "prefix" {
  description = "Name of my Prefix"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "vpc_cidr" {
  description = "The cidr of the VPC"
  type        = string
}

variable "subnet_cidr_private" {
  description = "CIDR blocks for the private subnets"
  type        = list(any)
}

variable "subnet_cidr_public" {
  description = "CIDR blocks for the public subnets"
  type        = list(any)
}

variable "availability_zone" {
  description = "availability zones for the private subnets"
  type        = list(any)
}

variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "monitoring_namespace" {
  type    = string
  default = "monitoring"
}

variable "argocd_namespace" {
  type    = string
}

