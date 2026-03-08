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

