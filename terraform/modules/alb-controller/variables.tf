variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for ALB controller"
  type        = string
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "issuer" {
  description = "OIDC issuer URL"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

